resource "google_cloud_run_v2_service" "service" {
  provider = google-beta
  name     = "my-service"
  location = var.region

  template {
    containers {
      image = "gcr.io/${var.project_id}/my-image"
    }

    vpc_access {
      connector = google_vpc_access_connector.connector.id
      egress    = "ALL_TRAFFIC"
    }
  }

  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }
}
