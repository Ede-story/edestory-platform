variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "domain_name" {
  description = "Main domain name (e.g., ede-story.com)"
  type        = string
}

variable "environment" {
  description = "Environment (dev/staging/prod)"
  type        = string
}

variable "corp_ip_address" {
  description = "IP address for corporate site"
  type        = string
}

variable "shop_ip_address" {
  description = "IP address for shop"
  type        = string
}

variable "n8n_ip_address" {
  description = "IP address for n8n"
  type        = string
  default     = ""
}

variable "corp_backend_group" {
  description = "Backend group for corporate site"
  type        = string
}

variable "shop_backend_group" {
  description = "Backend group for shop"
  type        = string
}

variable "create_root_record" {
  description = "Create A record for root domain"
  type        = bool
  default     = true
}

variable "create_www_record" {
  description = "Create CNAME for www"
  type        = bool
  default     = true
}

variable "create_n8n_record" {
  description = "Create A record for n8n"
  type        = bool
  default     = true
}

variable "mx_records" {
  description = "MX records for email"
  type        = list(string)
  default     = []
}

variable "txt_records" {
  description = "TXT records for verification"
  type        = list(string)
  default     = []
}