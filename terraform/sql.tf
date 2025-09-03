resource "google_sql_database_instance" "db" {
  name             = "bookmyshow-db"
  database_version = "POSTGRES_14"
  region           = var.region

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.vpc.id
    }
  }

  deletion_protection = false
  root_password       = "MySecurePass123"

  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
}
