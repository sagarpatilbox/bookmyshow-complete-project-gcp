output "mig_name" {
  value = google_compute_region_instance_group_manager.mig.name
}

output "lb_ip" {
  value = google_compute_global_address.default.address
}
