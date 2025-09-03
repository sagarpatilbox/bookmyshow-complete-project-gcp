resource "google_vpc_access_connector" "connector" {
  name          = "bookmyshow-connector"
  region        = var.region
  network       = google_compute_network.vpc.id
  ip_cidr_range = "10.8.0.0/28"
}
