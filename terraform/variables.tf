variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP Zone"
  type        = string
  default     = "us-central1-a"
}

# Network Variables
variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR range for subnet"
  type        = string
}

# Cloud Run Variables
variable "cloudrun_region" {
  description = "Region for Cloud Run services"
  type        = string
}

variable "shop_service_name" {
  description = "Name of the shop Cloud Run service"
  type        = string
}

variable "corp_service_name" {
  description = "Name of the corporate Cloud Run service"
  type        = string
}

# Database Variables
variable "db_instance_name" {
  description = "Name of the Cloud SQL instance"
  type        = string
}

variable "db_tier" {
  description = "Machine tier for database"
  type        = string
}

variable "db_version" {
  description = "PostgreSQL version"
  type        = string
  default     = "POSTGRES_15"
}

variable "db_backup_enabled" {
  description = "Enable automated backups"
  type        = bool
  default     = false
}

variable "db_high_availability" {
  description = "Enable high availability"
  type        = bool
  default     = false
}

# Storage Variables
variable "storage_bucket_name" {
  description = "Name of the GCS bucket"
  type        = string
}

variable "storage_location" {
  description = "Location for GCS bucket"
  type        = string
  default     = "US"
}

# Domain Variables
variable "domain_shop" {
  description = "Domain for shop"
  type        = string
}

variable "domain_corp" {
  description = "Domain for corporate site"
  type        = string
}

# Tags
variable "environment" {
  description = "Environment (dev/staging/prod)"
  type        = string
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod"
  }
}

variable "managed_by" {
  description = "Resource manager"
  type        = string
  default     = "terraform"
}