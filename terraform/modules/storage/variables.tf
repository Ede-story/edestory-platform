variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "bucket_name" {
  description = "Name of the GCS bucket"
  type        = string
}

variable "location" {
  description = "Location for GCS bucket"
  type        = string
  default     = "US"
}

variable "environment" {
  description = "Environment (dev/staging/prod)"
  type        = string
}

variable "enable_versioning" {
  description = "Enable versioning for main bucket"
  type        = bool
  default     = false
}

variable "lifecycle_age" {
  description = "Days before objects are deleted"
  type        = number
  default     = 90
}

variable "backup_retention_days" {
  description = "Days to retain backups"
  type        = number
  default     = 365
}

variable "cors_origins" {
  description = "CORS allowed origins"
  type        = list(string)
  default     = ["https://shop.ede-story.com", "https://www.ede-story.com"]
}