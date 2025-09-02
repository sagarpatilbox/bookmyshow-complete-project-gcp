provider "google" {
  project     = "bookmyshow-gcp"
  region      = var.region
  credentials = file("C:/Users/admin/AppData/Local/Google/Cloud SDK/bookmyshow-project-gcp/terraform/key.json")
}
