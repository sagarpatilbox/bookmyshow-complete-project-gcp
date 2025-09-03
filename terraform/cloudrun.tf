resource "google_service_account" "cloud_run_sa" {
  account_id   = "bookmyshow-cloudrun"
  display_name = "BookMyShow Cloud Run SA"
}

resource "google_project_iam_binding" "cloud_run_sql" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  members = ["serviceAccount:${google_service_account.cloud_run_sa.email}"]
}

resource "google_cloud_run_v2_service" "service" {
  name     = "bookmyshow-service"
  location = var.region

  template {
    service_account = google_service_account.cloud_run_sa.email
    containers {
      image = var.app_image
    }
    vpc_access {
      connector = google_vpc_access_connector.connector.id
    }
  }
}
