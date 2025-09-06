# Cloud DNS Module

# DNS Zone
resource "google_dns_managed_zone" "main" {
  name        = "${var.domain_name}-zone"
  dns_name    = "${var.domain_name}."
  description = "DNS zone for ${var.domain_name}"
  project     = var.project_id
  
  dnssec_config {
    state = "on"
  }
  
  labels = {
    environment = var.environment
    managed_by  = "terraform"
  }
}

# A Record for root domain (corporate site)
resource "google_dns_record_set" "root" {
  count = var.create_root_record ? 1 : 0
  
  name         = google_dns_managed_zone.main.dns_name
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.main.name
  project      = var.project_id
  
  rrdatas = [var.corp_ip_address]
}

# CNAME for www (if needed)
resource "google_dns_record_set" "www" {
  count = var.create_www_record ? 1 : 0
  
  name         = "www.${google_dns_managed_zone.main.dns_name}"
  type         = "CNAME"
  ttl          = 300
  managed_zone = google_dns_managed_zone.main.name
  project      = var.project_id
  
  rrdatas = [google_dns_managed_zone.main.dns_name]
}

# A Record for shop subdomain
resource "google_dns_record_set" "shop" {
  name         = "shop.${google_dns_managed_zone.main.dns_name}"
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.main.name
  project      = var.project_id
  
  rrdatas = [var.shop_ip_address]
}

# A Record for n8n subdomain
resource "google_dns_record_set" "n8n" {
  count = var.create_n8n_record ? 1 : 0
  
  name         = "n8n.${google_dns_managed_zone.main.dns_name}"
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.main.name
  project      = var.project_id
  
  rrdatas = [var.n8n_ip_address]
}

# MX Records for email
resource "google_dns_record_set" "mx" {
  count = length(var.mx_records) > 0 ? 1 : 0
  
  name         = google_dns_managed_zone.main.dns_name
  type         = "MX"
  ttl          = 3600
  managed_zone = google_dns_managed_zone.main.name
  project      = var.project_id
  
  rrdatas = var.mx_records
}

# TXT Records for domain verification and SPF
resource "google_dns_record_set" "txt" {
  count = length(var.txt_records) > 0 ? 1 : 0
  
  name         = google_dns_managed_zone.main.dns_name
  type         = "TXT"
  ttl          = 3600
  managed_zone = google_dns_managed_zone.main.name
  project      = var.project_id
  
  rrdatas = var.txt_records
}

# CAA Records for SSL certificate authority
resource "google_dns_record_set" "caa" {
  name         = google_dns_managed_zone.main.dns_name
  type         = "CAA"
  ttl          = 3600
  managed_zone = google_dns_managed_zone.main.name
  project      = var.project_id
  
  rrdatas = [
    "0 issue \"letsencrypt.org\"",
    "0 issue \"pki.goog\"",
    "0 issuewild \"letsencrypt.org\"",
    "0 issuewild \"pki.goog\""
  ]
}

# SSL Certificate for root domain and subdomains
resource "google_compute_managed_ssl_certificate" "main" {
  name    = "${replace(var.domain_name, ".", "-")}-ssl-cert"
  project = var.project_id
  
  managed {
    domains = concat(
      [var.domain_name],
      var.create_www_record ? ["www.${var.domain_name}"] : [],
      ["shop.${var.domain_name}"],
      var.create_n8n_record ? ["n8n.${var.domain_name}"] : []
    )
  }
}

# Global IP Address for Load Balancer
resource "google_compute_global_address" "main" {
  name    = "${replace(var.domain_name, ".", "-")}-global-ip"
  project = var.project_id
}

# Health Check
resource "google_compute_health_check" "https" {
  name               = "${replace(var.domain_name, ".", "-")}-health-check"
  check_interval_sec = 10
  timeout_sec        = 5
  project            = var.project_id
  
  https_health_check {
    port         = "443"
    request_path = "/"
  }
}

# Backend Service for Corporate Site
resource "google_compute_backend_service" "corp" {
  name        = "${replace(var.domain_name, ".", "-")}-corp-backend"
  project     = var.project_id
  protocol    = "HTTPS"
  timeout_sec = 30
  
  backend {
    group = var.corp_backend_group
  }
  
  health_checks = [google_compute_health_check.https.id]
  
  cdn_policy {
    cache_mode                   = "CACHE_ALL_STATIC"
    default_ttl                  = 3600
    client_ttl                   = 7200
    max_ttl                      = 86400
    negative_caching             = true
    serve_while_stale            = 86400
  }
}

# Backend Service for Shop
resource "google_compute_backend_service" "shop" {
  name        = "${replace(var.domain_name, ".", "-")}-shop-backend"
  project     = var.project_id
  protocol    = "HTTPS"
  timeout_sec = 30
  
  backend {
    group = var.shop_backend_group
  }
  
  health_checks = [google_compute_health_check.https.id]
  
  cdn_policy {
    cache_mode                   = "CACHE_ALL_STATIC"
    default_ttl                  = 3600
    client_ttl                   = 7200
    max_ttl                      = 86400
    negative_caching             = true
    serve_while_stale            = 86400
  }
}

# URL Map (Routing)
resource "google_compute_url_map" "main" {
  name            = "${replace(var.domain_name, ".", "-")}-url-map"
  project         = var.project_id
  default_service = google_compute_backend_service.corp.id
  
  host_rule {
    hosts        = ["shop.${var.domain_name}"]
    path_matcher = "shop"
  }
  
  host_rule {
    hosts        = [var.domain_name, "www.${var.domain_name}"]
    path_matcher = "corp"
  }
  
  path_matcher {
    name            = "shop"
    default_service = google_compute_backend_service.shop.id
  }
  
  path_matcher {
    name            = "corp"
    default_service = google_compute_backend_service.corp.id
  }
}

# HTTPS Proxy
resource "google_compute_target_https_proxy" "main" {
  name             = "${replace(var.domain_name, ".", "-")}-https-proxy"
  project          = var.project_id
  url_map          = google_compute_url_map.main.id
  ssl_certificates = [google_compute_managed_ssl_certificate.main.id]
}

# Global Forwarding Rule
resource "google_compute_global_forwarding_rule" "main" {
  name       = "${replace(var.domain_name, ".", "-")}-forwarding-rule"
  project    = var.project_id
  ip_address = google_compute_global_address.main.address
  port_range = "443"
  target     = google_compute_target_https_proxy.main.id
}

# HTTP to HTTPS Redirect
resource "google_compute_url_map" "redirect" {
  name    = "${replace(var.domain_name, ".", "-")}-redirect"
  project = var.project_id
  
  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
  }
}

resource "google_compute_target_http_proxy" "redirect" {
  name    = "${replace(var.domain_name, ".", "-")}-http-proxy"
  project = var.project_id
  url_map = google_compute_url_map.redirect.id
}

resource "google_compute_global_forwarding_rule" "redirect" {
  name       = "${replace(var.domain_name, ".", "-")}-http-forwarding"
  project    = var.project_id
  ip_address = google_compute_global_address.main.address
  port_range = "80"
  target     = google_compute_target_http_proxy.redirect.id
}