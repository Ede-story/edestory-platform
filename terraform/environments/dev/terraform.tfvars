# Development Environment Variables
project_id = "rosy-stronghold-467817-k6"
region     = "us-central1"
zone       = "us-central1-a"

# Network Configuration
vpc_name = "edestory-vpc-dev"
subnet_cidr = "10.0.1.0/24"

# Cloud Run Configuration
cloudrun_region = "us-central1"
shop_service_name = "edestory-shop-dev"
corp_service_name = "edestory-corp-dev"

# Database Configuration
db_instance_name = "edestory-db-dev"
db_tier = "db-f1-micro"  # Минимальный tier для dev
db_version = "POSTGRES_15"
db_backup_enabled = false
db_high_availability = false

# Storage Configuration
storage_bucket_name = "edestory-assets-dev"
storage_location = "US"

# Domain Configuration
domain_shop = "shop-dev.ede-story.com"
domain_corp = "dev.ede-story.com"

# Tags
environment = "dev"
managed_by = "terraform"