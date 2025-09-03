variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "region" {
  type        = string
  default     = "asia-south1"
}

variable "zone" {
  type        = string
  default     = "asia-south1-a"
}

variable "app_image" {
  type        = string
  description = "Container image for the BookMyShow app"
}

variable "domain_name" {
  type        = string
  description = "Domain name for HTTPS load balancer"
}

variable "force_destroy_bucket" {
  type    = bool
  default = false
}
