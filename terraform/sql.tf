resource "google_sql_database_instance" "db" {
  name             = "bookmyshow-db"
  database_version = "POSTGRES_14"
  region           = var.region

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.vpc.self_link
    }
  }

  deletion_protection = false

  lifecycle {
    prevent_destroy = false
    ignore_changes  = all
  }
}

resource "google_sql_user" "root" {
  name     = "postgres"
  instance = google_sql_database_instance.db.name
  password = var.db_password
}
