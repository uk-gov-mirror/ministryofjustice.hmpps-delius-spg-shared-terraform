# # LB
output "ecs_spg_lb_id" {
  value = "${module.ecs-spg.lb_id}"
}

output "ecs_spg_lb_arn" {
  value = "${module.ecs-spg.lb_arn}"
}

output "ecs_spg_lb_arn_suffix" {
  value = "${module.ecs-spg.lb_arn_suffix}"
}

output "ecs_spg_lb_dns_name" {
  value = "${module.ecs-spg.lb_dns_name}"
}

output "ecs_spg_lb_dns_alias" {
  value = "${module.ecs-spg.lb_dns_alias}"
}

# TARGET GROUPS
output "ecs_spg_target_group_id" {
  value = "${module.ecs-spg.target_group_id}"
}

output "ecs_spg_target_group_arn" {
  value = "${module.ecs-spg.target_group_arn}"
}

output "ecs_spg_target_group_arn_suffix" {
  value = "${module.ecs-spg.target_group_arn_suffix}"
}

output "ecs_spg_target_group_name" {
  value = "${module.ecs-spg.target_group_name}"
}

# LISTENER
output "ecs_spg_https_lb_listener_id" {
  value = "${module.ecs-spg.https_lb_listener_id}"
}

output "ecs_spg_https_lb_listener_arn" {
  value = "${module.ecs-spg.https_lb_listener_arn}"
}

output "ecs_spg_http_lb_listener_id" {
  value = "${module.ecs-spg.http_lb_listener_id}"
}

output "ecs_spg_http_lb_listener_arn" {
  value = "${module.ecs-spg.http_lb_listener_arn}"
}

# ECS CLUSTER
output "ecs_spg_ecs_cluster_arn" {
  value = "${module.ecs-spg.ecs_cluster_arn}"
}

output "ecs_spg_ecs_cluster_id" {
  value = "${module.ecs-spg.ecs_cluster_id}"
}

output "ecs_spg_ecs_cluster_name" {
  value = "${module.ecs-spg.ecs_cluster_name}"
}

# LOG GROUPS
output "ecs_spg_loggroup_arn" {
  value = "${module.ecs-spg.loggroup_arn}"
}

output "ecs_spg_loggroup_name" {
  value = "${module.ecs-spg.loggroup_name}"
}

# TASK DEFINITION
output "ecs_spg_task_definition_arn" {
  value = "${module.ecs-spg.task_definition_arn}"
}

output "ecs_spg_task_definition_family" {
  value = "${module.ecs-spg.task_definition_family}"
}

output "ecs_spg_task_definition_revision" {
  value = "${module.ecs-spg.task_definition_revision}"
}

# ECS SERVICE
output "ecs_spg_service_id" {
  value = "${module.ecs-spg.ecs_service_id}"
}

output "ecs_spg_service_name" {
  value = "${module.ecs-spg.ecs_service_name}"
}

output "ecs_spg_service_cluster" {
  value = "${module.ecs-spg.ecs_service_cluster}"
}

# Launch config
output "ecs_spg_launch_id" {
  value = "${module.ecs-spg.launch_id}"
}

output "ecs_spg_launch_name" {
  value = "${module.ecs-spg.launch_name}"
}

# ASG
output "autoscale_id" {
  value = "${module.ecs-spg.autoscale_id}"
}

output "ecs_spg_autoscale_arn" {
  value = "${module.ecs-spg.autoscale_arn}"
}

output "ecs_spg_autoscale_name" {
  value = "${module.ecs-spg.autoscale_name}"
}
