resource "google_artifact_registry_repository" "repo" {
  location      = var.region
  repository_id = "bookmyshow"
  format        = "DOCKER"
}

resource "google_storage_bucket" "static" {
  name     = "${var.project_id}-static-assets"
  location = var.region
  force_destroy = true
  uniform_bucket_level_access = true
}

resource "google_sql_database_instance" "bookmyshow_db" {
  name             = "bookmyshow-db"
  database_version = "POSTGRES_14"
  region           = var.region
  settings {
    tier = "db-f1-micro"
    backup_configuration { enabled = true }
    availability_type = "ZONAL"
  }
}

resource "google_sql_user" "db_user" {
  name     = "bookmyshow"
  instance = google_sql_database_instance.bookmyshow_db.name
  password = var.db_password
}

resource "google_redis_instance" "redis" {
  name           = "bookmyshow-redis"
  tier           = "BASIC"
  memory_size_gb = 1
  region         = var.region
  location_id    = "${var.region}-a"
}

resource "google_vpc_access_connector" "connector" {
  name   = "bookmyshow-connector"
  region = var.region
  network = "default"
  ip_cidr_range = "10.8.0.0/28"
}

resource "google_service_account" "run_sa" {
  account_id   = "bookmyshow-run-sa"
  display_name = "Cloud Run service account for BookMyShow"
}

resource "google_project_iam_member" "run_storage_reader" {
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.run_sa.email}"
}

resource "google_cloud_run_service" "service" {
  name     = var.service_name
  location = var.region
  template {
    spec {
      containers {
        image = var.app_image
        env {
          name  = "DB_INSTANCE_CONNECTION_NAME"
          value = google_sql_database_instance.bookmyshow_db.connection_name
        }
      }
      service_account_name = google_service_account.run_sa.email
      vpc_access { connector = google_vpc_access_connector.connector.id egress = "ALL_TRAFFIC" }
    }
  }
  traffics { percent = 100 latest_revision = true }
}

resource "google_cloud_run_service_iam_member" "invoker" {
  service  = google_cloud_run_service.service.name
  location = google_cloud_run_service.service.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}
