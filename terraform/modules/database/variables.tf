variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
}

variable "instance_name" {
  description = "Name of the Cloud SQL instance"
  type        = string
}

variable "database_version" {
  description = "PostgreSQL version"
  type        = string
  default     = "POSTGRES_15"
}

variable "tier" {
  description = "Machine tier for database"
  type        = string
}

variable "vpc_id" {
  description = "VPC network ID"
  type        = string
}

variable "private_ip_address" {
  description = "Private IP address for database"
  type        = string
}

variable "private_vpc_connection" {
  description = "Private VPC connection"
  type        = string
}

variable "backup_enabled" {
  description = "Enable automated backups"
  type        = bool
  default     = false
}

variable "high_availability" {
  description = "Enable high availability"
  type        = bool
  default     = false
}

variable "environment" {
  description = "Environment (dev/staging/prod)"
  type        = string
}

variable "disk_size" {
  description = "Disk size in GB"
  type        = number
  default     = 10
}

variable "max_connections" {
  description = "Maximum number of connections"
  type        = string
  default     = "100"
}

variable "shared_buffers" {
  description = "Shared buffers size"
  type        = string
  default     = "256000"
}