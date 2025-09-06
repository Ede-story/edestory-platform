# Cloud Run Module

# Cloud Run Service
resource "google_cloud_run_service" "service" {
  name     = var.service_name
  location = var.region
  project  = var.project_id
  
  template {
    spec {
      containers {
        image = var.image
        
        ports {
          container_port = 3000
        }
        
        # Environment variables
        dynamic "env" {
          for_each = var.env_vars
          content {
            name  = env.key
            value = env.value
          }
        }
        
        # Secret environment variables
        dynamic "env" {
          for_each = var.secret_env_vars
          content {
            name = env.key
            value_from {
              secret_key_ref {
                name = env.value.secret_name
                key  = env.value.secret_key
              }
            }
          }
        }
        
        resources {
          limits = {
            cpu    = var.cpu_limit
            memory = var.memory_limit
          }
        }
      }
      
      # VPC Connector for private networking
      container_concurrency = var.max_instances_per_container
      timeout_seconds      = var.timeout_seconds
      service_account_name = google_service_account.service_account.email
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
        service_type = var.service_type
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

# Service Account for Cloud Run
resource "google_service_account" "service_account" {
  account_id   = "${var.service_name}-sa"
  display_name = "Service Account for ${var.service_name}"
  project      = var.project_id
}

# IAM bindings for service account
resource "google_project_iam_member" "service_account_roles" {
  for_each = toset([
    "roles/cloudsql.client",
    "roles/storage.objectViewer",
    "roles/storage.objectCreator",
    "roles/secretmanager.secretAccessor",
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter"
  ])
  
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

# Public access (if needed)
resource "google_cloud_run_service_iam_member" "public_access" {
  count = var.allow_public_access ? 1 : 0
  
  service  = google_cloud_run_service.service.name
  location = google_cloud_run_service.service.location
  project  = var.project_id
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# Custom domain mapping
resource "google_cloud_run_domain_mapping" "domain" {
  count = var.domain != "" ? 1 : 0
  
  location = var.region
  name     = var.domain
  project  = var.project_id
  
  metadata {
    namespace = var.project_id
    labels = {
      environment = var.environment
      managed_by  = "terraform"
    }
  }
  
  spec {
    route_name = google_cloud_run_service.service.name
  }
}

# Health check for monitoring
resource "google_monitoring_uptime_check_config" "health_check" {
  display_name = "${var.service_name}-health-check"
  timeout      = "10s"
  period       = "60s"
  project      = var.project_id
  
  http_check {
    path         = var.health_check_path
    port         = "443"
    use_ssl      = true
    validate_ssl = true
  }
  
  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = var.project_id
      host       = var.domain != "" ? var.domain : "${google_cloud_run_service.service.status[0].url}"
    }
  }
}

# Alert policy for service downtime
resource "google_monitoring_alert_policy" "downtime_alert" {
  display_name = "${var.service_name}-downtime-alert"
  combiner     = "OR"
  project      = var.project_id
  enabled      = var.environment == "prod"
  
  conditions {
    display_name = "Service is down"
    
    condition_threshold {
      filter          = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" AND resource.type=\"uptime_url\" AND metric.label.check_id=\"${google_monitoring_uptime_check_config.health_check.uptime_check_id}\""
      duration        = "300s"
      comparison      = "COMPARISON_LT"
      threshold_value = 1
      
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
    }
  }
  
  notification_channels = var.notification_channels
}