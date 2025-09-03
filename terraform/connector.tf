resource "google_vpc_access_connector" "connector" {
  name    = "bookmyshow-connector"
  region  = var.region
  network = google_compute_network.vpc.name

  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
}
