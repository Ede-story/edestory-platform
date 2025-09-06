# Production Environment Variables
project_id = "rosy-stronghold-467817-k6"
region     = "us-central1"
zone       = "us-central1-a"

# Network Configuration
vpc_name = "edestory-vpc-prod"
subnet_cidr = "10.1.1.0/24"

# Cloud Run Configuration
cloudrun_region = "us-central1"
shop_service_name = "edestory-shop-prod"
corp_service_name = "edestory-corp-prod"

# Database Configuration
db_instance_name = "edestory-db-prod"
db_tier = "db-g1-small"  # Production tier
db_version = "POSTGRES_15"
db_backup_enabled = true
db_high_availability = true

# Storage Configuration
storage_bucket_name = "edestory-assets-prod"
storage_location = "US"

# Domain Configuration
domain_shop = "shop.ede-story.com"
domain_corp = "ede-story.com"

# Tags
environment = "prod"
managed_by = "terraform"