resource "google_artifact_registry_repository" "repo" {
  provider      = google
  location      = var.region
  repository_id = "bookmyshow"
  format        = "DOCKER"
}

resource "google_storage_bucket" "bucket" {
  name          = "${var.project_id}-bucket"
  location      = var.region
  force_destroy = true
}

resource "google_sql_database_instance" "db" {
  name             = "bookmyshow-db"
  database_version = "POSTGRES_14"
  region           = var.region

  settings {
    tier = "db-custom-1-3840"
  }

  root_password = var.db_password
}

resource "google_redis_instance" "cache" {
  name           = "bookmyshow-redis"
  tier           = "BASIC"
  memory_size_gb = 1
  region         = var.region
}


resource "google_vpc_access_connector" "connector" {
  name          = "bookmyshow-connector"
  region        = var.region
  network       = var.network
  ip_cidr_range = "10.8.0.0/28" # required for VPC connector
}

resource "google_cloud_run_v2_service" "service" {
  name     = "bookmyshow-service"
  location = var.region

  template {
    containers {
      image = var.app_image
    }
    vpc_access {
      connector = google_vpc_access_connector.connector.id
    }
  }
}
