terraform {
  required_version = ">= 1.3.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0"
    }
  }

  backend "gcs" {
    bucket = "bookmyshow-terraform-state"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}
resource "google_cloud_run_service" "bookmyshow" {
  name     = "bookmyshow-service"
  location = "asia-south1"

  template {
    spec {
      containers {
        # Use latest image pushed to Artifact Registry
        image = "asia-south1-docker.pkg.dev/${var.project_id}/bookmyshow-repo/bookmyshow:${var.commit_sha}"
        resources {
          limits = {
            cpu    = "1"
            memory = "512Mi"
          }
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

output "cloud_run_service_url" {
  value = google_cloud_run_service.bookmyshow.status[0].url
}
