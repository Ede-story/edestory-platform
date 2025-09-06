# Storage Module - Google Cloud Storage

# Main storage bucket
resource "google_storage_bucket" "main" {
  name          = var.bucket_name
  location      = var.location
  project       = var.project_id
  force_destroy = var.environment != "prod"
  
  uniform_bucket_level_access = true
  
  versioning {
    enabled = var.enable_versioning
  }
  
  lifecycle_rule {
    condition {
      age = var.lifecycle_age
    }
    action {
      type = "Delete"
    }
  }
  
  lifecycle_rule {
    condition {
      num_newer_versions = 3
    }
    action {
      type = "Delete"
    }
  }
  
  cors {
    origin          = var.cors_origins
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
  
  labels = {
    environment = var.environment
    managed_by  = "terraform"
    purpose     = "assets"
  }
}

# Public assets bucket
resource "google_storage_bucket" "public" {
  name          = "${var.bucket_name}-public"
  location      = var.location
  project       = var.project_id
  force_destroy = var.environment != "prod"
  
  uniform_bucket_level_access = false
  
  cors {
    origin          = ["*"]
    method          = ["GET", "HEAD"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
  
  labels = {
    environment = var.environment
    managed_by  = "terraform"
    purpose     = "public-assets"
  }
}

# Backup bucket
resource "google_storage_bucket" "backup" {
  name          = "${var.bucket_name}-backup"
  location      = var.location
  project       = var.project_id
  force_destroy = false
  
  uniform_bucket_level_access = true
  
  versioning {
    enabled = true
  }
  
  lifecycle_rule {
    condition {
      age = var.backup_retention_days
    }
    action {
      type = "Delete"
    }
  }
  
  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
  }
  
  lifecycle_rule {
    condition {
      age = 90
    }
    action {
      type          = "SetStorageClass"
      storage_class = "COLDLINE"
    }
  }
  
  lifecycle_rule {
    condition {
      age = 365
    }
    action {
      type          = "SetStorageClass"
      storage_class = "ARCHIVE"
    }
  }
  
  labels = {
    environment = var.environment
    managed_by  = "terraform"
    purpose     = "backup"
  }
}

# IAM for public bucket
resource "google_storage_bucket_iam_member" "public_viewer" {
  bucket = google_storage_bucket.public.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

# Service account for storage access
resource "google_service_account" "storage" {
  account_id   = "${var.bucket_name}-sa"
  display_name = "Storage Service Account"
  project      = var.project_id
}

# IAM bindings for service account
resource "google_storage_bucket_iam_member" "main_admin" {
  bucket = google_storage_bucket.main.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.storage.email}"
}

resource "google_storage_bucket_iam_member" "public_admin" {
  bucket = google_storage_bucket.public.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.storage.email}"
}

resource "google_storage_bucket_iam_member" "backup_admin" {
  bucket = google_storage_bucket.backup.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.storage.email}"
}

# CDN configuration for public bucket
resource "google_compute_backend_bucket" "cdn" {
  name        = "${var.bucket_name}-cdn"
  bucket_name = google_storage_bucket.public.name
  project     = var.project_id
  
  enable_cdn = true
  
  cdn_policy {
    cache_mode                   = "CACHE_ALL_STATIC"
    client_ttl                   = 3600
    default_ttl                  = 3600
    max_ttl                      = 86400
    negative_caching             = true
    serve_while_stale            = 86400
    signed_url_cache_max_age_sec = 7200
    
    negative_caching_policy {
      code = 404
      ttl  = 120
    }
    
    negative_caching_policy {
      code = 410
      ttl  = 120
    }
  }
}