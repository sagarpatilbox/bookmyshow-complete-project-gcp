resource "google_cloud_run_service" "service" {
  name     = "bookmyshow-service"
  location = var.region

  template {
    spec {
      containers {
        image = "gcr.io/${var.project_id}/bookmyshow-app"
      }
    }
  }

  traffics {
    percent         = 100
    latest_revision = true
  }

  vpc_access {
    connector = google_vpc_access_connector.connector.id
    egress    = "ALL_TRAFFIC"
  }
}
