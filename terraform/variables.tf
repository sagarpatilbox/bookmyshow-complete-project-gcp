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
