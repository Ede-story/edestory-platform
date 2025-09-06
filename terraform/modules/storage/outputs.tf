output "bucket_name" {
  value       = google_storage_bucket.main.name
  description = "Name of the main storage bucket"
}

output "public_bucket_name" {
  value       = google_storage_bucket.public.name
  description = "Name of the public storage bucket"
}

output "backup_bucket_name" {
  value       = google_storage_bucket.backup.name
  description = "Name of the backup storage bucket"
}

output "bucket_url" {
  value       = google_storage_bucket.main.url
  description = "URL of the main storage bucket"
}

output "public_bucket_url" {
  value       = "https://storage.googleapis.com/${google_storage_bucket.public.name}"
  description = "Public URL of the public storage bucket"
}

output "cdn_url" {
  value       = google_compute_backend_bucket.cdn.self_link
  description = "CDN URL for public assets"
}

output "service_account_email" {
  value       = google_service_account.storage.email
  description = "Service account email for storage access"
}