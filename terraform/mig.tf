resource "google_compute_instance_template" "tmpl" {
  name_prefix  = "bookmyshow-template-"   # use name_prefix to avoid conflicts
  machine_type = "e2-micro"

  disk {
    boot         = true
    auto_delete  = true
    source_image = "debian-cloud/debian-11"
  }

  network_interface {
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
    instance_template = google_compute_instance_template.tmpl.self_link
  }

  target_size = 1

  auto_healing_policies {
    health_check      = google_compute_health_check.hc.id
    initial_delay_sec = 60
  }

  update_policy {
    type                  = "PROACTIVE"
    minimal_action        = "RESTART"
    max_surge_fixed       = 3
    max_unavailable_fixed = 3
  }

  lifecycle {
    create_before_destroy = true
  }
}
