# Cloud SQL PostgreSQL Module

# Random password for database
resource "random_password" "db_password" {
  length  = 32
  special = true
}

# Cloud SQL Instance
resource "google_sql_database_instance" "postgres" {
  name             = var.instance_name
  database_version = var.database_version
  region           = var.region
  project          = var.project_id
  
  settings {
    tier              = var.tier
    availability_type = var.high_availability ? "REGIONAL" : "ZONAL"
    disk_size         = var.disk_size
    disk_type         = "PD_SSD"
    disk_autoresize   = true
    
    backup_configuration {
      enabled                        = var.backup_enabled
      start_time                     = "03:00"
      point_in_time_recovery_enabled = var.backup_enabled
      transaction_log_retention_days = var.backup_enabled ? 7 : 0
      
      backup_retention_settings {
        retained_backups = var.backup_enabled ? 30 : 1
        retention_unit   = "COUNT"
      }
    }
    
    ip_configuration {
      ipv4_enabled    = false
      private_network = var.vpc_id
      require_ssl     = true
    }
    
    database_flags {
      name  = "max_connections"
      value = var.max_connections
    }
    
    database_flags {
      name  = "shared_buffers"
      value = var.shared_buffers
    }
    
    database_flags {
      name  = "log_statement"
      value = "all"
    }
    
    insights_config {
      query_insights_enabled  = true
      query_string_length    = 1024
      record_application_tags = true
      record_client_address  = true
    }
    
    maintenance_window {
      day          = 7  # Sunday
      hour         = 4  # 4 AM
      update_track = "stable"
    }
    
    user_labels = {
      environment = var.environment
      managed_by  = "terraform"
    }
  }
  
  deletion_protection = var.environment == "prod"
  
  depends_on = [var.private_vpc_connection]
}

# Database for Saleor
resource "google_sql_database" "saleor_db" {
  name     = "saleor"
  instance = google_sql_database_instance.postgres.name
  project  = var.project_id
}

# Database for Corporate Site
resource "google_sql_database" "corp_db" {
  name     = "corporate"
  instance = google_sql_database_instance.postgres.name
  project  = var.project_id
}

# Database User for Saleor
resource "google_sql_user" "saleor_user" {
  name     = "saleor_user"
  instance = google_sql_database_instance.postgres.name
  password = random_password.db_password.result
  project  = var.project_id
}

# Database User for Corporate
resource "google_sql_user" "corp_user" {
  name     = "corp_user"
  instance = google_sql_database_instance.postgres.name
  password = random_password.db_password.result
  project  = var.project_id
}

# Database for n8n
resource "google_sql_database" "n8n_db" {
  name     = "n8n"
  instance = google_sql_database_instance.postgres.name
  project  = var.project_id
}

# Database User for n8n
resource "google_sql_user" "n8n_user" {
  name     = "n8n_user"
  instance = google_sql_database_instance.postgres.name
  password = random_password.db_password.result
  project  = var.project_id
}

# Store passwords in Secret Manager
resource "google_secret_manager_secret" "db_password_saleor" {
  secret_id = "${var.instance_name}-saleor-password"
  project   = var.project_id
  
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "db_password_saleor_version" {
  secret      = google_secret_manager_secret.db_password_saleor.id
  secret_data = random_password.db_password.result
}

resource "google_secret_manager_secret" "db_password_corp" {
  secret_id = "${var.instance_name}-corp-password"
  project   = var.project_id
  
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "db_password_corp_version" {
  secret      = google_secret_manager_secret.db_password_corp.id
  secret_data = random_password.db_password.result
}

# Connection string secrets
resource "google_secret_manager_secret" "connection_string_saleor" {
  secret_id = "${var.instance_name}-saleor-connection"
  project   = var.project_id
  
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "connection_string_saleor_version" {
  secret      = google_secret_manager_secret.connection_string_saleor.id
  secret_data = "postgresql://${google_sql_user.saleor_user.name}:${random_password.db_password.result}@${google_sql_database_instance.postgres.private_ip_address}:5432/${google_sql_database.saleor_db.name}?sslmode=require"
}

resource "google_secret_manager_secret" "connection_string_corp" {
  secret_id = "${var.instance_name}-corp-connection"
  project   = var.project_id
  
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "connection_string_corp_version" {
  secret      = google_secret_manager_secret.connection_string_corp.id
  secret_data = "postgresql://${google_sql_user.corp_user.name}:${random_password.db_password.result}@${google_sql_database_instance.postgres.private_ip_address}:5432/${google_sql_database.corp_db.name}?sslmode=require"
}

# Password secret for n8n
resource "google_secret_manager_secret" "db_password_n8n" {
  secret_id = "${var.instance_name}-n8n-password"
  project   = var.project_id
  
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "db_password_n8n_version" {
  secret      = google_secret_manager_secret.db_password_n8n.id
  secret_data = random_password.db_password.result
}

# Monitoring alert for database
resource "google_monitoring_alert_policy" "database_alert" {
  display_name = "${var.instance_name}-database-alert"
  combiner     = "OR"
  project      = var.project_id
  enabled      = var.environment == "prod"
  
  conditions {
    display_name = "Database CPU usage high"
    
    condition_threshold {
      filter          = "metric.type=\"cloudsql.googleapis.com/database/cpu/utilization\" AND resource.type=\"cloudsql_database\" AND resource.label.database_id=\"${var.project_id}:${google_sql_database_instance.postgres.name}\""
      duration        = "300s"
      comparison      = "COMPARISON_GT"
      threshold_value = 0.8
      
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }
  
  conditions {
    display_name = "Database memory usage high"
    
    condition_threshold {
      filter          = "metric.type=\"cloudsql.googleapis.com/database/memory/utilization\" AND resource.type=\"cloudsql_database\" AND resource.label.database_id=\"${var.project_id}:${google_sql_database_instance.postgres.name}\""
      duration        = "300s"
      comparison      = "COMPARISON_GT"
      threshold_value = 0.9
      
      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }
}