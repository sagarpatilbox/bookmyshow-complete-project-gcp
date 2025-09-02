# Cloud Run Service URL
output "cloud_run_service_url" {
  description = "The URL of the deployed Cloud Run service"
  value       = google_cloud_run_v2_service.service.uri
}

# VPC Connector Name
output "vpc_connector_name" {
  description = "The name of the VPC connector used by Cloud Run"
  value       = google_vpc_access_connector.connector.name
}
