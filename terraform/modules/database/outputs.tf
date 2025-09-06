output "instance_name" {
  value       = google_sql_database_instance.postgres.name
  description = "Name of the Cloud SQL instance"
}

output "private_ip_address" {
  value       = google_sql_database_instance.postgres.private_ip_address
  description = "Private IP address of the database"
}

output "connection_string" {
  value       = google_secret_manager_secret_version.connection_string_saleor_version.secret_data
  sensitive   = true
  description = "Database connection string for Saleor"
}

output "saleor_connection_secret" {
  value       = google_secret_manager_secret.connection_string_saleor.id
  description = "Secret ID for Saleor connection string"
}

output "corp_connection_secret" {
  value       = google_secret_manager_secret.connection_string_corp.id
  description = "Secret ID for Corporate connection string"
}

output "saleor_db_name" {
  value       = google_sql_database.saleor_db.name
  description = "Saleor database name"
}

output "corp_db_name" {
  value       = google_sql_database.corp_db.name
  description = "Corporate database name"
}

output "n8n_password_secret" {
  value       = google_secret_manager_secret.db_password_n8n.id
  description = "Secret ID for n8n database password"
}

output "n8n_db_name" {
  value       = google_sql_database.n8n_db.name
  description = "n8n database name"
}