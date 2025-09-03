resource "google_storage_bucket" "bucket" {
  name          = "${var.project_id}-bucket"
  location      = var.region
  force_destroy = var.force_destroy_bucket
}
