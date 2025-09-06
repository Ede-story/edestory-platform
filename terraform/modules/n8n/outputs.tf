output "service_url" {
  value       = google_cloud_run_service.n8n.status[0].url
  description = "URL of the n8n service"
}

output "service_name" {
  value       = google_cloud_run_service.n8n.name
  description = "Name of the n8n service"
}

output "service_account_email" {
  value       = google_service_account.n8n_sa.email
  description = "Service account email for n8n"
}

output "encryption_key_secret" {
  value       = google_secret_manager_secret.n8n_encryption_key.id
  description = "Secret ID for n8n encryption key"
  sensitive   = true
}