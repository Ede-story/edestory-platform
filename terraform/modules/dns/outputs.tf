output "zone_name" {
  value       = google_dns_managed_zone.main.name
  description = "DNS zone name"
}

output "name_servers" {
  value       = google_dns_managed_zone.main.name_servers
  description = "Name servers for the DNS zone"
}

output "global_ip_address" {
  value       = google_compute_global_address.main.address
  description = "Global IP address for the load balancer"
}

output "ssl_certificate_id" {
  value       = google_compute_managed_ssl_certificate.main.id
  description = "SSL certificate ID"
}

output "shop_url" {
  value       = "https://shop.${var.domain_name}"
  description = "Shop URL"
}

output "corp_url" {
  value       = "https://${var.domain_name}"
  description = "Corporate site URL"
}

output "n8n_url" {
  value       = var.create_n8n_record ? "https://n8n.${var.domain_name}" : ""
  description = "n8n URL"
}