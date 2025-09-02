terraform {
  required_version = ">= 1.3.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "core" {
  source     = "./modules/core"
  project_id = var.project_id
  region     = var.region
  network    = var.network
  db_password = var.db_password
  app_image   = var.app_image
}

module "mig_lb" {
  source     = "./modules/mig_lb"
  project_id = var.project_id
  region     = var.region
  zone       = "asia-south1-a"

  # required args
  network   = var.network
  app_image = var.app_image
}
