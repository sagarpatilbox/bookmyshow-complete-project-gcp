variable "region" {
  description = "The region to deploy resources"
  type        = string
}

variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "network" {
  description = "The VPC network name for Cloud Run VPC connector"
  type        = string
  default     = "default"
}

variable "db_password" {
  description = "The password for the Cloud SQL database"
  type        = string
  sensitive   = true
}

variable "app_image" {
  description = "The container image for Cloud Run service"
  type        = string
}
