resource "google_cloud_run_service" "service" {
  name     = "bookmyshow-service"
  location = var.region

  template {
    spec {
      containers {
        image = "gcr.io/${var.project_id}/bookmyshow-app:latest"
      }
    }

    metadata {
      annotations = {
        "run.googleapis.com/vpc-access-connector" = google_vpc_access_connector.connector.id
        "run.googleapis.com/vpc-egress"           = "all-traffic"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}
