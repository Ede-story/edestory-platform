variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "Region for n8n service"
  type        = string
}

variable "service_name" {
  description = "Name of the n8n service"
  type        = string
  default     = "n8n-automation"
}

variable "n8n_image" {
  description = "Docker image for n8n"
  type        = string
  default     = "n8nio/n8n:latest"
}

variable "n8n_user" {
  description = "Basic auth username for n8n"
  type        = string
  default     = "admin"
}

variable "n8n_domain" {
  description = "Custom domain for n8n"
  type        = string
  default     = ""
}

variable "database_host" {
  description = "Database host"
  type        = string
}

variable "database_password_secret" {
  description = "Secret ID for database password"
  type        = string
}

variable "vpc_connector" {
  description = "VPC Connector ID"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Environment (dev/staging/prod)"
  type        = string
}

variable "cpu_limit" {
  description = "CPU limit for the container"
  type        = string
  default     = "2"
}

variable "memory_limit" {
  description = "Memory limit for the container"
  type        = string
  default     = "2Gi"
}

variable "min_instances" {
  description = "Minimum number of instances"
  type        = number
  default     = 0
}

variable "max_instances" {
  description = "Maximum number of instances"
  type        = number
  default     = 10
}

variable "allow_public_access" {
  description = "Allow public access to n8n"
  type        = bool
  default     = true
}