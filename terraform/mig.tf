resource "google_compute_instance_template" "tmpl" {
  name         = "bookmyshow-template"
  machine_type = "e2-medium"

  disk {
    source_image = "projects/cos-cloud/global/images/family/cos-stable"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network = google_compute_network.vpc.id
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    set -e
    docker-credential-gcr configure-docker
    docker run -d -p 8080:8080 ${var.app_image}
  EOT

  tags = ["bookmyshow-mig"]
}

resource "google_compute_region_instance_group_manager" "mig" {
  name               = "bookmyshow-mig"
  base_instance_name = "bookmyshow"
  region             = var.region

  version {
    instance_template = google_compute_instance_template.tmpl.id
  }

  target_size = 1

  auto_healing_policies {
    health_check      = google_compute_health_check.hc.id
    initial_delay_sec = 60
  }
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

resource "google_compute_health_check" "hc" {
  name = "bookmyshow-hc"
  http_health_check {
    port = 8080
  }
}
