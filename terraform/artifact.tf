resource "google_artifact_registry_repository" "repo" {
  location      = var.region
  repository_id = "bookmyshow-repo"   # ✅ match manual repo
  format        = "DOCKER"

  lifecycle {
    prevent_destroy = false
    ignore_changes  = all
  }
}

