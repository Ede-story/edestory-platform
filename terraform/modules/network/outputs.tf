output "vpc_id" {
  value       = google_compute_network.vpc.id
  description = "VPC ID"
}

output "vpc_name" {
  value       = google_compute_network.vpc.name
  description = "VPC Name"
}

output "subnet_id" {
  value       = google_compute_subnetwork.subnet.id
  description = "Subnet ID"
}

output "vpc_connector" {
  value       = google_vpc_access_connector.connector.id
  description = "VPC Connector for Cloud Run"
}

output "database_ip" {
  value       = google_compute_global_address.database_ip.address
  description = "Reserved IP for database"
}

output "private_vpc_connection" {
  value       = google_service_networking_connection.private_vpc_connection.id
  description = "Private VPC connection for services"
}