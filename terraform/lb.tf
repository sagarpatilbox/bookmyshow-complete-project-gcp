resource "google_compute_backend_service" "backend" {
  name                  = "bookmyshow-backend"
  protocol              = "HTTP"
  port_name             = "http"
  timeout_sec           = 30
  load_balancing_scheme = "EXTERNAL"
  health_checks         = [google_compute_health_check.hc.id]

  backend {
    group = google_compute_region_instance_group_manager.mig.instance_group
  }
}

resource "google_compute_url_map" "urlmap" {
  name            = "bookmyshow-urlmap"
  default_service = google_compute_backend_service.backend.id
}

resource "google_compute_managed_ssl_certificate" "cert" {
  name = "bookmyshow-cert"
  managed {
    domains = [var.domain_name]
  }
}

resource "google_compute_target_https_proxy" "https_proxy" {
  name             = "bookmyshow-https-proxy"
  ssl_certificates = [google_compute_managed_ssl_certificate.cert.id]
  url_map          = google_compute_url_map.urlmap.id
}

resource "google_compute_global_address" "ip" {
  name = "bookmyshow-lb-ip"
}

resource "google_compute_global_forwarding_rule" "https_rule" {
  name       = "bookmyshow-https-rule"
  ip_address = google_compute_global_address.ip.address
  port_range = "443"
  target     = google_compute_target_https_proxy.https_proxy.id
}

resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "bookmyshow-http-proxy"
  url_map = google_compute_url_map.urlmap.id
}

resource "google_compute_global_forwarding_rule" "http_rule" {
  name       = "bookmyshow-http-rule"
  ip_address = google_compute_global_address.ip.address
  port_range = "80"
  target     = google_compute_target_http_proxy.http_proxy.id
}
