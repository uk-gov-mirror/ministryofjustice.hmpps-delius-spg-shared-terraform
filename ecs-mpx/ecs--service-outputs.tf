# ECS CLUSTER
output "ecs_spg_ecs_cluster_arn" {
  value = module.ecs_cluster.ecs_cluster_arn
}

output "ecs_spg_ecs_cluster_id" {
  value = module.ecs_cluster.ecs_cluster_id
}

output "ecs_spg_ecs_cluster_name" {
  value = module.ecs_cluster.ecs_cluster_name
}

# LOG GROUPS
output "ecs_spg_application_loggroup_arn" {
  value = module.create_application_loggroup.loggroup_arn
}

output "ecs_spg_application_loggroup_name" {
  value = module.create_application_loggroup.loggroup_name
}

output "ecs_spg_infrastructure_loggroup_arn" {
  value = module.create_infrastructure_loggroup.loggroup_arn
}

output "ecs_spg_infrastructure_loggroup_name" {
  value = module.create_infrastructure_loggroup.loggroup_name
}

# ECS SERVICE
output "ecs_spg_service_id" {
  value = module.app_service.ecs_service_id
}

output "ecs_spg_service_name" {
  value = module.app_service.ecs_service_name
}

output "ecs_spg_service_cluster" {
  value = module.app_service.ecs_service_cluster
}

# Launch config
output "ecs_spg_launch_id" {
  value = module.launch_cfg.launch_id
}

output "ecs_spg_launch_name" {
  value = module.launch_cfg.launch_name
}

# ASG
output "autoscale_id" {
  value = module.auto_scale.autoscale_id
}

output "ecs_spg_autoscale_arn" {
  value = module.auto_scale.autoscale_arn
}

output "ecs_spg_autoscale_name" {
  value = module.auto_scale.autoscale_name
}

