resource "google_compute_instance_template" "template" {
  name_prefix = "bms-template-"
  properties {
    machine_type = "e2-medium"
    disks {
      boot = true
      initialize_params {
        image = "projects/cos-cloud/global/images/family/cos-stable"
      }
    }
    network_interfaces { network = "default" }
    metadata_startup_script = <<-EOT
      #!/bin/bash
      apt-get update
      apt-get install -y docker.io
      docker run -d -p 8080:8080 ${var.app_image}
    EOT
  }
}

resource "google_compute_region_instance_group_manager" "mig" {
  name = "bookmyshow-mig"
  region = var.region
  base_instance_name = "bookmyshow"
  version { instance_template = google_compute_instance_template.template.self_link }
  target_size = 2
}

resource "google_compute_health_check" "hc" {
  name = "bookmyshow-hc"
  http_health_check { request_path = "/health" port = 8080 }
}

resource "google_compute_backend_service" "backend" {
  name = "bookmyshow-backend"
  protocol = "HTTP"
  health_checks = [google_compute_health_check.hc.self_link]
  backend { group = google_compute_region_instance_group_manager.mig.instance_group }
}

resource "google_compute_url_map" "url_map" {
  name = "bookmyshow-url-map"
  default_service = google_compute_backend_service.backend.self_link
}

resource "google_compute_target_http_proxy" "proxy" {
  name = "bookmyshow-http-proxy"
  url_map = google_compute_url_map.url_map.self_link
}

resource "google_compute_global_forwarding_rule" "forward" {
  name = "bookmyshow-forward"
  target = google_compute_target_http_proxy.proxy.self_link
  port_range = "80"
}

resource "google_compute_autoscaler" "autoscaler" {
  name = "bookmyshow-autoscaler"
  region = var.region
  target = google_compute_region_instance_group_manager.mig.self_link
  autoscaling_policy {
    max_replicas = 10
    min_replicas = 2
    cpu_utilization { target = 0.6 }
  }
}
