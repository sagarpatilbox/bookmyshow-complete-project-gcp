output "cloud_run_service_url" {
  value = module.core.cloud_run_service_url
}

output "vpc_connector_name" {
  value = module.core.vpc_connector_name
}

output "mig_instance_group" {
  value = module.mig_lb.mig_name
}

output "load_balancer_ip" {
  value = module.mig_lb.lb_ip
}
