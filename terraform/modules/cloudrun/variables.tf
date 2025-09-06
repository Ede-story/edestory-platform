variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "Region for Cloud Run service"
  type        = string
}

variable "service_name" {
  description = "Name of the Cloud Run service"
  type        = string
}

variable "image" {
  description = "Docker image URL"
  type        = string
}

variable "vpc_connector" {
  description = "VPC Connector ID for private networking"
  type        = string
  default     = ""
}

variable "database_url" {
  description = "Database connection string"
  type        = string
  sensitive   = true
}

variable "storage_bucket" {
  description = "GCS bucket name for storage"
  type        = string
}

variable "domain" {
  description = "Custom domain for the service"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Environment (dev/staging/prod)"
  type        = string
}

variable "service_type" {
  description = "Type of service (shop/corporate)"
  type        = string
}

variable "env_vars" {
  description = "Environment variables"
  type        = map(string)
  default     = {}
}

variable "secret_env_vars" {
  description = "Secret environment variables"
  type = map(object({
    secret_name = string
    secret_key  = string
  }))
  default = {}
}

variable "cpu_limit" {
  description = "CPU limit for the container"
  type        = string
  default     = "1"
}

variable "memory_limit" {
  description = "Memory limit for the container"
  type        = string
  default     = "512Mi"
}

variable "min_instances" {
  description = "Minimum number of instances"
  type        = number
  default     = 0
}

variable "max_instances" {
  description = "Maximum number of instances"
  type        = number
  default     = 100
}

variable "max_instances_per_container" {
  description = "Maximum concurrent requests per container"
  type        = number
  default     = 80
}

variable "timeout_seconds" {
  description = "Request timeout in seconds"
  type        = number
  default     = 300
}

variable "allow_public_access" {
  description = "Allow public access to the service"
  type        = bool
  default     = true
}

variable "health_check_path" {
  description = "Path for health check"
  type        = string
  default     = "/"
}

variable "notification_channels" {
  description = "Notification channels for alerts"
  type        = list(string)
  default     = []
}