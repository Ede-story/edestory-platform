terraform {
  required_version = ">= 1.5.0"
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.0"
    }
  }

  # Backend configuration for state storage
  backend "gcs" {
    bucket = "edestory-terraform-state"
    prefix = "terraform/state"
  }
}

# Provider Configuration
provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

# Enable required APIs
resource "google_project_service" "required_apis" {
  for_each = toset([
    "run.googleapis.com",
    "sqladmin.googleapis.com",
    "compute.googleapis.com",
    "servicenetworking.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudbuild.googleapis.com",
    "artifactregistry.googleapis.com",
    "secretmanager.googleapis.com",
    "iap.googleapis.com",
    "dns.googleapis.com",
    "vpcaccess.googleapis.com",
    "cloudscheduler.googleapis.com",
    "monitoring.googleapis.com"
  ])
  
  service = each.key
  disable_on_destroy = false
}

# Modules
module "network" {
  source = "./modules/network"
  
  project_id   = var.project_id
  region       = var.region
  vpc_name     = var.vpc_name
  subnet_cidr  = var.subnet_cidr
  environment  = var.environment
  
  depends_on = [google_project_service.required_apis]
}

module "database" {
  source = "./modules/database"
  
  project_id             = var.project_id
  region                 = var.region
  instance_name          = var.db_instance_name
  database_version       = var.db_version
  tier                   = var.db_tier
  vpc_id                 = module.network.vpc_id
  private_ip_address     = module.network.database_ip
  private_vpc_connection = module.network.private_vpc_connection
  backup_enabled         = var.db_backup_enabled
  high_availability      = var.db_high_availability
  environment            = var.environment
  
  depends_on = [module.network]
}

module "storage" {
  source = "./modules/storage"
  
  project_id   = var.project_id
  bucket_name  = var.storage_bucket_name
  location     = var.storage_location
  environment  = var.environment
  
  depends_on = [google_project_service.required_apis]
}

module "cloudrun_shop" {
  source = "./modules/cloudrun"
  
  project_id        = var.project_id
  region           = var.cloudrun_region
  service_name     = var.shop_service_name
  image            = "gcr.io/${var.project_id}/edestory-shop:latest"
  vpc_connector    = module.network.vpc_connector
  database_url     = module.database.connection_string
  storage_bucket   = module.storage.bucket_name
  domain           = var.domain_shop
  environment      = var.environment
  service_type     = "shop"
  
  env_vars = {
    NODE_ENV                = var.environment == "prod" ? "production" : "development"
    NEXT_PUBLIC_SALEOR_URL = "https://api.saleor.io/graphql/"
    DATABASE_URL           = module.database.connection_string
    STORAGE_BUCKET         = module.storage.bucket_name
  }
  
  depends_on = [module.network, module.database, module.storage]
}

module "cloudrun_corp" {
  source = "./modules/cloudrun"
  
  project_id        = var.project_id
  region           = var.cloudrun_region
  service_name     = var.corp_service_name
  image            = "gcr.io/${var.project_id}/edestory-corp:latest"
  vpc_connector    = module.network.vpc_connector
  database_url     = module.database.connection_string
  storage_bucket   = module.storage.bucket_name
  domain           = var.domain_corp
  environment      = var.environment
  service_type     = "corporate"
  
  env_vars = {
    NODE_ENV       = var.environment == "prod" ? "production" : "development"
    DATABASE_URL   = module.database.connection_string
    STORAGE_BUCKET = module.storage.bucket_name
  }
  
  depends_on = [module.network, module.database, module.storage]
}

# n8n automation platform
module "n8n" {
  source = "./modules/n8n"
  
  project_id               = var.project_id
  region                   = var.region
  service_name             = "n8n-automation-${var.environment}"
  n8n_domain               = var.environment == "prod" ? "n8n.ede-story.com" : ""
  database_host            = module.database.private_ip_address
  database_password_secret = module.database.n8n_password_secret
  vpc_connector            = module.network.vpc_connector
  environment              = var.environment
  
  depends_on = [module.network, module.database]
}

# DNS and SSL Configuration
module "dns" {
  source = "./modules/dns"
  count  = var.environment == "prod" ? 1 : 0  # Only create DNS for production
  
  project_id         = var.project_id
  domain_name        = "ede-story.com"
  environment        = var.environment
  corp_ip_address    = module.cloudrun_corp.service_url
  shop_ip_address    = module.cloudrun_shop.service_url
  n8n_ip_address     = module.n8n.service_url
  corp_backend_group = module.cloudrun_corp.service_url
  shop_backend_group = module.cloudrun_shop.service_url
  
  depends_on = [module.cloudrun_corp, module.cloudrun_shop, module.n8n]
}

# Artifact Registry for Docker images
resource "google_artifact_registry_repository" "docker_repo" {
  location      = var.region
  repository_id = "edestory-docker"
  description   = "Docker repository for Edestory platform"
  format        = "DOCKER"
  
  depends_on = [google_project_service.required_apis]
}

# Outputs
output "shop_url" {
  value = module.cloudrun_shop.service_url
  description = "URL of the shop service"
}

output "corp_url" {
  value = module.cloudrun_corp.service_url
  description = "URL of the corporate website"
}

output "database_instance" {
  value = module.database.instance_name
  sensitive = true
  description = "Database instance name"
}

output "storage_bucket" {
  value = module.storage.bucket_name
  description = "Storage bucket name"
}

output "n8n_url" {
  value = module.n8n.service_url
  description = "URL of the n8n automation service"
}