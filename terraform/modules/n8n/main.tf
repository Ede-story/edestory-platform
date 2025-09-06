# n8n Automation Module

# Random password for n8n
resource "random_password" "n8n_password" {
  length  = 32
  special = true
}

# Secret for n8n encryption key
resource "google_secret_manager_secret" "n8n_encryption_key" {
  secret_id = "${var.service_name}-encryption-key"
  project   = var.project_id
  
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "n8n_encryption_key_version" {
  secret      = google_secret_manager_secret.n8n_encryption_key.id
  secret_data = random_password.n8n_password.result
}

# Service Account for n8n
resource "google_service_account" "n8n_sa" {
  account_id   = "${var.service_name}-sa"
  display_name = "Service Account for n8n"
  project      = var.project_id
}

# IAM bindings for n8n service account
resource "google_project_iam_member" "n8n_roles" {
  for_each = toset([
    "roles/cloudsql.client",
    "roles/storage.objectAdmin",
    "roles/secretmanager.secretAccessor",
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/run.invoker",
    "roles/cloudscheduler.admin"
  ])
  
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.n8n_sa.email}"
}

# Cloud Run Service for n8n
resource "google_cloud_run_service" "n8n" {
  name     = var.service_name
  location = var.region
  project  = var.project_id
  
  template {
    spec {
      containers {
        image = var.n8n_image
        
        ports {
          container_port = 5678
        }
        
        env {
          name  = "N8N_BASIC_AUTH_ACTIVE"
          value = "true"
        }
        
        env {
          name  = "N8N_BASIC_AUTH_USER"
          value = var.n8n_user
        }
        
        env {
          name = "N8N_BASIC_AUTH_PASSWORD"
          value_from {
            secret_key_ref {
              name = google_secret_manager_secret.n8n_encryption_key.secret_id
              key  = "latest"
            }
          }
        }
        
        env {
          name  = "N8N_HOST"
          value = var.n8n_domain != "" ? "https://${var.n8n_domain}" : ""
        }
        
        env {
          name  = "N8N_PROTOCOL"
          value = "https"
        }
        
        env {
          name  = "N8N_PORT"
          value = "5678"
        }
        
        env {
          name  = "DB_TYPE"
          value = "postgresdb"
        }
        
        env {
          name  = "DB_POSTGRESDB_HOST"
          value = var.database_host
        }
        
        env {
          name  = "DB_POSTGRESDB_PORT"
          value = "5432"
        }
        
        env {
          name  = "DB_POSTGRESDB_DATABASE"
          value = "n8n"
        }
        
        env {
          name  = "DB_POSTGRESDB_USER"
          value = "n8n_user"
        }
        
        env {
          name = "DB_POSTGRESDB_PASSWORD"
          value_from {
            secret_key_ref {
              name = var.database_password_secret
              key  = "latest"
            }
          }
        }
        
        env {
          name  = "N8N_ENCRYPTION_KEY"
          value_from {
            secret_key_ref {
              name = google_secret_manager_secret.n8n_encryption_key.secret_id
              key  = "latest"
            }
          }
        }
        
        env {
          name  = "WEBHOOK_URL"
          value = var.n8n_domain != "" ? "https://${var.n8n_domain}" : ""
        }
        
        env {
          name  = "N8N_METRICS"
          value = "true"
        }
        
        env {
          name  = "N8N_LOG_LEVEL"
          value = var.environment == "prod" ? "info" : "debug"
        }
        
        env {
          name  = "EXECUTIONS_DATA_PRUNE"
          value = "true"
        }
        
        env {
          name  = "EXECUTIONS_DATA_MAX_AGE"
          value = "336" # 14 days
        }
        
        env {
          name  = "N8N_PAYLOAD_SIZE_MAX"
          value = "16"
        }
        
        env {
          name  = "GENERIC_TIMEZONE"
          value = "Europe/Moscow"
        }
        
        resources {
          limits = {
            cpu    = var.cpu_limit
            memory = var.memory_limit
          }
        }
      }
      
      container_concurrency = 100
      timeout_seconds      = 3600 # 1 hour for long workflows
      service_account_name = google_service_account.n8n_sa.email
    }
    
    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale"        = var.min_instances
        "autoscaling.knative.dev/maxScale"        = var.max_instances
        "run.googleapis.com/vpc-access-connector" = var.vpc_connector
        "run.googleapis.com/vpc-access-egress"    = "all-traffic"
        "run.googleapis.com/execution-environment" = "gen2"
      }
      
      labels = {
        environment  = var.environment
        service_type = "automation"
        managed_by   = "terraform"
      }
    }
  }
  
  traffic {
    percent         = 100
    latest_revision = true
  }
  
  autogenerate_revision_name = true
}

# IAM for public access (if needed)
resource "google_cloud_run_service_iam_member" "n8n_public" {
  count = var.allow_public_access ? 1 : 0
  
  service  = google_cloud_run_service.n8n.name
  location = google_cloud_run_service.n8n.location
  project  = var.project_id
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# Custom domain mapping
resource "google_cloud_run_domain_mapping" "n8n_domain" {
  count = var.n8n_domain != "" ? 1 : 0
  
  location = var.region
  name     = var.n8n_domain
  project  = var.project_id
  
  metadata {
    namespace = var.project_id
    labels = {
      environment = var.environment
      managed_by  = "terraform"
    }
  }
  
  spec {
    route_name = google_cloud_run_service.n8n.name
  }
}

# Cloud Scheduler for periodic tasks
resource "google_cloud_scheduler_job" "n8n_cleanup" {
  name        = "${var.service_name}-cleanup"
  description = "Clean up old n8n executions"
  schedule    = "0 2 * * *" # Daily at 2 AM
  time_zone   = "Europe/Moscow"
  project     = var.project_id
  region      = var.region
  
  http_target {
    uri         = "${google_cloud_run_service.n8n.status[0].url}/webhook/cleanup"
    http_method = "POST"
    
    oidc_token {
      service_account_email = google_service_account.n8n_sa.email
      audience             = google_cloud_run_service.n8n.status[0].url
    }
  }
}

# Monitoring uptime check
resource "google_monitoring_uptime_check_config" "n8n_health" {
  display_name = "${var.service_name}-health-check"
  timeout      = "10s"
  period       = "300s" # Every 5 minutes
  project      = var.project_id
  
  http_check {
    path         = "/healthz"
    port         = "443"
    use_ssl      = true
    validate_ssl = true
  }
  
  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = var.project_id
      host       = var.n8n_domain != "" ? var.n8n_domain : "${google_cloud_run_service.n8n.status[0].url}"
    }
  }
}