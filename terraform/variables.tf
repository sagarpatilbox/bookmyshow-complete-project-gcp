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

variable "app_image" {
  description = "Docker image for the Cloud Run service"
  type        = string
}

variable "db_password" {
  description = "Password for the Cloud SQL database"
  type        = string
  sensitive   = true
}

variable "db_user" {
  description = "Username for the Cloud SQL database"
  type        = string
  default     = "root"
}
