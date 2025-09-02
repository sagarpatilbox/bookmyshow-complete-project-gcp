output "cloud_run_url" { value = google_cloud_run_service.service.status[0].url }
output "mig_forwarding_ip" { value = google_compute_global_forwarding_rule.forward.ip_address }
output "sql_connection_name" { value = google_sql_database_instance.bookmyshow_db.connection_name }
output "artifact_repo" { value = google_artifact_registry_repository.repo.repository_id }
