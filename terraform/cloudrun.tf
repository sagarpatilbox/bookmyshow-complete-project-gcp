resource "google_cloud_run_v2_service" "bookmyshow" {
  name     = "bookmyshow-service"
  location = var.region
  project  = var.project_id
  deletion_protection = false

  template {
    containers {
      image = "asia-south1-docker.pkg.dev/${var.project_id}/bookmyshow-repo/bookmyshow:latest"
    }
  }

  ingress = "INGRESS_TRAFFIC_ALL"
}