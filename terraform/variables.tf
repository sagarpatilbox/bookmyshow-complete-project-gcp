variable "project_id" { type = string }
variable "region" { type = string default = "asia-south1" }
variable "app_image" { type = string }
variable "db_password" { type = string sensitive = true }
variable "service_name" { type = string default = "bookmyshow-service" }
