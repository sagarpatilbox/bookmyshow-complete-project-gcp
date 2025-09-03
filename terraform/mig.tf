resource "google_compute_instance_template" "tmpl" {
  name         = "bookmyshow-template"
  machine_type = "e2-micro"

  disk {
    boot         = true
    auto_delete  = true
    source_image = "debian-cloud/debian-11"
  }

  network_interface {
    # Use the self_link of your subnet created in network.tf
    subnetwork = google_compute_subnetwork.subnet.self_link
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update -y
    apt-get install -y nginx
    systemctl start nginx
  EOT
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

resource "google_compute_region_autoscaler" "autoscaler" {
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
