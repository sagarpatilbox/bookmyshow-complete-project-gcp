resource "google_compute_instance_template" "default" {
  name         = "bookmyshow-template"
  machine_type = "e2-medium"
  region       = var.region

  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network = var.network
    access_config {}
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update -y
    apt-get install -y docker.io
    docker run -d -p 80:80 ${var.app_image}
  EOT
}

resource "google_compute_region_instance_group_manager" "mig" {
  name               = "bookmyshow-mig"
  base_instance_name = "bookmyshow"
  region             = var.region
  version {
    instance_template = google_compute_instance_template.default.id
  }
  target_size = 1
}

resource "google_compute_autoscaler" "autoscaler" {
  name   = "bookmyshow-autoscaler"
  region = var.region
  target = google_compute_region_instance_group_manager.mig.id

  autoscaling_policy {
    max_replicas    = 5
    min_replicas    = 1
    cpu_utilization {
      target = 0.6
    }
  }
}

resource "google_compute_global_address" "default" {
  name = "lb-ip"
}

resource "google_compute_backend_service" "default" {
  name                  = "bookmyshow-backend"
  load_balancing_scheme = "EXTERNAL"
  backend {
    group = google_compute_region_instance_group_manager.mig.instance_group
  }
  connection_draining_timeout_sec = 10
  port_name                       = "http"
  protocol                        = "HTTP"
}

resource "google_compute_url_map" "default" {
  name            = "bookmyshow-url-map"
  default_service = google_compute_backend_service.default.id
}

resource "google_compute_target_http_proxy" "default" {
  name   = "bookmyshow-proxy"
  url_map = google_compute_url_map.default.id
}

resource "google_compute_global_forwarding_rule" "default" {
  name       = "bookmyshow-forwarding-rule"
  target     = google_compute_target_http_proxy.default.id
  port_range = "80"
  ip_address = google_compute_global_address.default.address
}
