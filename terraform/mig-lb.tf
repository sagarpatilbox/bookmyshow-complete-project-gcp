resource "google_compute_health_check" "hc" {
  name = "bookmyshow-health-check"

  http_health_check {
    request_path = "/health"
    port         = 8080
  }
}
