terraform {
  required_version = ">= 1.0"
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  backend "gcs" {
    bucket = "edestory-terraform-state"
    prefix = "shop/state"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

variable "project_id" {
  description = "GCP Project ID"
  default     = "edestory-platform"
}

variable "region" {
  description = "GCP Region"
  default     = "europe-west1"
}

variable "zone" {
  description = "GCP Zone"
  default     = "europe-west1-b"
}

# Enable required APIs
resource "google_project_service" "apis" {
  for_each = toset([
    "run.googleapis.com",
    "cloudbuild.googleapis.com",
    "secretmanager.googleapis.com",
    "sqladmin.googleapis.com",
    "cloudscheduler.googleapis.com",
    "storage.googleapis.com",
    "compute.googleapis.com",
    "servicenetworking.googleapis.com"
  ])
  
  service            = each.value
  disable_on_destroy = false
}

# Cloud SQL for PostgreSQL (Saleor database)
resource "google_sql_database_instance" "saleor" {
  name             = "edestory-db"
  database_version = "POSTGRES_15"
  region           = var.region
  deletion_protection = true

  settings {
    tier              = "db-g1-small" # Empezamos pequeño, escalamos según necesidad
    availability_type = "REGIONAL"    # Alta disponibilidad
    disk_size         = 20            # GB
    disk_type         = "PD_SSD"
    disk_autoresize   = true
    disk_autoresize_limit = 100

    backup_configuration {
      enabled                        = true
      start_time                     = "02:00"
      point_in_time_recovery_enabled = true
      transaction_log_retention_days = 7
      backup_retention_settings {
        retained_backups = 30
        retention_unit   = "COUNT"
      }
    }

    ip_configuration {
      ipv4_enabled    = false  # Solo conexiones privadas
      private_network = google_compute_network.vpc.self_link
    }

    database_flags {
      name  = "max_connections"
      value = "100"
    }

    insights_config {
      query_insights_enabled  = true
      query_string_length    = 1024
      record_application_tags = true
      record_client_address  = true
    }
  }

  depends_on = [google_service_networking_connection.private_vpc_connection]
}

# Database for Saleor
resource "google_sql_database" "saleor" {
  name     = "saleor"
  instance = google_sql_database_instance.saleor.name
}

# Database user
resource "google_sql_user" "saleor" {
  name     = "saleor"
  instance = google_sql_database_instance.saleor.name
  password = random_password.db_password.result
}

# Random password for database
resource "random_password" "db_password" {
  length  = 32
  special = true
}

# Store password in Secret Manager
resource "google_secret_manager_secret" "db_password" {
  secret_id = "saleor-db-password"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "db_password" {
  secret      = google_secret_manager_secret.db_password.id
  secret_data = random_password.db_password.result
}

# VPC Network
resource "google_compute_network" "vpc" {
  name                    = "edestory-vpc"
  auto_create_subnetworks = false
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "edestory-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = var.region
  network       = google_compute_network.vpc.id
}

# Private service connection for Cloud SQL
resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

# Cloud Storage buckets
resource "google_storage_bucket" "media" {
  name          = "${var.project_id}-media"
  location      = "EU"
  force_destroy = false
  
  uniform_bucket_level_access = true
  
  cors {
    origin          = ["https://shop.ede-story.com"]
    method          = ["GET", "HEAD"]
    response_header = ["*"]
    max_age_seconds = 3600
  }

  lifecycle_rule {
    condition {
      age = 90
    }
    action {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
  }

  lifecycle_rule {
    condition {
      age = 365
    }
    action {
      type          = "SetStorageClass"
      storage_class = "ARCHIVE"
    }
  }
}

resource "google_storage_bucket" "static" {
  name          = "${var.project_id}-static"
  location      = "EU"
  force_destroy = false
  
  uniform_bucket_level_access = false  # Permitir acceso público para static files
  
  cors {
    origin          = ["*"]
    method          = ["GET", "HEAD"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}

# Cloud Run service for Next.js frontend
resource "google_cloud_run_service" "frontend" {
  name     = "edestory-shop"
  location = var.region

  template {
    spec {
      containers {
        image = "gcr.io/${var.project_id}/edestory-shop:latest"
        
        ports {
          container_port = 8080
        }

        resources {
          limits = {
            cpu    = "1"
            memory = "1Gi"
          }
        }

        env {
          name  = "NODE_ENV"
          value = "production"
        }

        env {
          name = "DATABASE_URL"
          value_from {
            secret_key_ref {
              name = google_secret_manager_secret.database_url.secret_id
              key  = "latest"
            }
          }
        }
      }

      service_account_name = google_service_account.frontend.email
      
      # Cloud SQL connection
      metadata {
        annotations = {
          "run.googleapis.com/cloudsql-instances" = google_sql_database_instance.saleor.connection_name
        }
      }
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale"     = "10"
        "autoscaling.knative.dev/minScale"     = "1"
        "run.googleapis.com/startup-cpu-boost" = "true"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

# Cloud Run service for Saleor API
resource "google_cloud_run_service" "saleor_api" {
  name     = "saleor-api"
  location = var.region

  template {
    spec {
      containers {
        image = "gcr.io/${var.project_id}/saleor:latest"
        
        ports {
          container_port = 8000
        }

        resources {
          limits = {
            cpu    = "2"
            memory = "2Gi"
          }
        }

        env {
          name = "DATABASE_URL"
          value_from {
            secret_key_ref {
              name = google_secret_manager_secret.database_url.secret_id
              key  = "latest"
            }
          }
        }

        env {
          name  = "REDIS_URL"
          value = "redis://${google_redis_instance.cache.host}:${google_redis_instance.cache.port}"
        }
      }

      service_account_name = google_service_account.saleor.email
      
      metadata {
        annotations = {
          "run.googleapis.com/cloudsql-instances" = google_sql_database_instance.saleor.connection_name
          "run.googleapis.com/vpc-access-connector" = google_vpc_access_connector.connector.id
        }
      }
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = "20"
        "autoscaling.knative.dev/minScale" = "2"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

# Redis instance for caching
resource "google_redis_instance" "cache" {
  name           = "edestory-cache"
  tier           = "BASIC"
  memory_size_gb = 1
  region         = var.region
  
  authorized_network = google_compute_network.vpc.id
  redis_version     = "REDIS_7_0"
  
  display_name = "Edestory Cache"
}

# VPC Access Connector for Cloud Run
resource "google_vpc_access_connector" "connector" {
  name          = "edestory-connector"
  region        = var.region
  ip_cidr_range = "10.1.0.0/28"
  network       = google_compute_network.vpc.name
  
  machine_type = "e2-micro"
  min_instances = 2
  max_instances = 10
}

# Service accounts
resource "google_service_account" "frontend" {
  account_id   = "frontend-sa"
  display_name = "Frontend Service Account"
}

resource "google_service_account" "saleor" {
  account_id   = "saleor-sa"
  display_name = "Saleor API Service Account"
}

resource "google_service_account" "n8n" {
  account_id   = "n8n-sa"
  display_name = "n8n Automation Service Account"
}

# IAM roles
resource "google_project_iam_member" "frontend_roles" {
  for_each = toset([
    "roles/cloudsql.client",
    "roles/secretmanager.secretAccessor",
    "roles/storage.objectViewer"
  ])
  
  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.frontend.email}"
}

resource "google_project_iam_member" "saleor_roles" {
  for_each = toset([
    "roles/cloudsql.client",
    "roles/secretmanager.secretAccessor",
    "roles/storage.admin"
  ])
  
  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.saleor.email}"
}

# Cloud Scheduler for n8n workflows
resource "google_cloud_scheduler_job" "product_sync" {
  name             = "aliexpress-product-sync"
  description      = "Sync products from AliExpress every 4 hours"
  schedule         = "0 */4 * * *"
  time_zone        = "Europe/Madrid"
  attempt_deadline = "600s"

  http_target {
    http_method = "POST"
    uri         = "https://n8n.ede-story.com/webhook/product-sync"
    
    headers = {
      "Content-Type" = "application/json"
    }
    
    body = base64encode(jsonencode({
      trigger = "scheduled"
    }))

    oidc_token {
      service_account_email = google_service_account.n8n.email
    }
  }

  retry_config {
    retry_count = 3
  }
}

# Secret for database URL
resource "google_secret_manager_secret" "database_url" {
  secret_id = "database-url"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "database_url" {
  secret = google_secret_manager_secret.database_url.id
  secret_data = "postgresql://saleor:${random_password.db_password.result}@/${google_sql_database.saleor.name}?host=/cloudsql/${google_sql_database_instance.saleor.connection_name}"
}

# Load balancer with Cloud CDN
resource "google_compute_backend_service" "cdn" {
  name                  = "edestory-cdn"
  protocol              = "HTTPS"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  
  cdn_policy {
    cache_mode                   = "CACHE_ALL_STATIC"
    default_ttl                  = 3600
    max_ttl                      = 86400
    client_ttl                   = 3600
    negative_caching             = true
    serve_while_stale            = 86400
    signed_url_cache_max_age_sec = 7200
  }

  backend {
    group = google_compute_region_network_endpoint_group.frontend_neg.id
  }
}

# Network endpoint group for Cloud Run
resource "google_compute_region_network_endpoint_group" "frontend_neg" {
  name                  = "frontend-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  
  cloud_run {
    service = google_cloud_run_service.frontend.name
  }
}

# Outputs
output "frontend_url" {
  value = google_cloud_run_service.frontend.status[0].url
}

output "api_url" {
  value = google_cloud_run_service.saleor_api.status[0].url
}

output "database_instance" {
  value = google_sql_database_instance.saleor.connection_name
}

output "media_bucket" {
  value = google_storage_bucket.media.url
}

output "static_bucket" {
  value = google_storage_bucket.static.url
}