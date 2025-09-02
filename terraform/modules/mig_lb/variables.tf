variable "project_id" { type = string }
variable "region" { type = string }
variable "network" { type = string }
variable "app_image" { type = string }
variable "zone" {
  description = "Zone for MIG and autoscaler"
  type        = string
}
