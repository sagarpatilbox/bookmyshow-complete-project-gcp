resource "google_cloudbuild_trigger" "trigger" {
  name = "bookmyshow-trigger"
  # Configure GitHub connection and repo details before apply
  github { owner = "REPLACE_OWNER" name = "REPLACE_REPO" push { branch = "main" } }
  filename = "cloudbuild.yaml"
}
