resource "google_storage_bucket" "bucket" {
  name     = "${var.project_id}-bucket"
  location = var.region

  lifecycle {
    prevent_destroy = false
    ignore_changes  = all
  }
}

