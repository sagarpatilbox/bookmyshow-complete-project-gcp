resource "google_redis_instance" "cache" {
  name           = "bookmyshow-redis"
  tier           = "BASIC"
  memory_size_gb = 1
  region         = var.region

  lifecycle {
    prevent_destroy = true
    ignore_changes  = all
  }
}
