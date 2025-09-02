resource "google_vpc_access_connector" "connector" {
  name          = "run-vpc-connector"
  region        = var.region
  network       = var.network  # Your VPC network name (default or custom)
  ip_cidr_range = "10.8.0.0/28" # Must be a free /28 block in your VPC
}
