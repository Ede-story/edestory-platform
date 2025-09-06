output "service_url" {
  value       = google_cloud_run_service.service.status[0].url
  description = "URL of the Cloud Run service"
}

output "service_name" {
  value       = google_cloud_run_service.service.name
  description = "Name of the Cloud Run service"
}

output "service_account_email" {
  value       = google_service_account.service_account.email
  description = "Service account email"
}

output "latest_revision" {
  value       = google_cloud_run_service.service.status[0].latest_ready_revision_name
  description = "Latest ready revision name"
}