output "cloud_run_service_url" {
  description = "The URL of the Cloud Run service"
  value       = google_cloud_run_v2_service.bookmyshow.uri
}

output "vpc_connector_name" {
  description = "The name of the VPC connector"
  value       = google_vpc_access_connector.connector.name
}

output "mig_name" {
  description = "The name of the Managed Instance Group"
  value       = google_compute_region_instance_group_manager.mig.name
}

output "lb_ip" {
  description = "The external IP address of the HTTPS Load Balancer"
  value       = google_compute_global_address.ip.address
}
