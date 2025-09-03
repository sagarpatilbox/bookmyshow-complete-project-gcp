output "cloud_run_service_url" {
  value = google_cloud_run_service.bookmyshow.status[0].url
}

output "vpc_connector_name" {
  value = google_vpc_access_connector.connector.name
}

output "mig_name" {
  value = google_compute_region_instance_group_manager.mig.name
}

output "lb_ip" {
  value = google_compute_global_address.ip.address
}

