output "cloud_run_service_url" {
  value = google_cloud_run_v2_service.service.uri
}

output "vpc_connector_name" {
  value = google_vpc_access_connector.connector.name
}
