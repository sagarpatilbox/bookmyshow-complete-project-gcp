resource "google_cloudbuild_trigger" "trigger" {
  name = "bookmyshow-trigger"

  github {
    owner = "sagarpatilbox"
    name  = "bookmyshow-project-gcp"

    push {
      branch = "main"
    }
  }

  filename = "cloudbuild.yaml"
}
