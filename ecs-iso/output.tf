# # LB int
//output "ecs_spg_lb_int_id" {
//  value = "${module.ecs-iso.lb_int_id}"
//}
//
//output "ecs_spg_lb_int_arn" {
//  value = "${module.ecs-iso.lb_int_arn}"
//}
//
//output "ecs_spg_lb_int_arn_suffix" {
//  value = "${module.ecs-iso.lb_int_arn_suffix}"
//}
//
//output "ecs_spg_lb_int_dns_name" {
//  value = "${module.ecs-iso.lb_int_dns_name}"
//}
//
//output "ecs_spg_lb_int_dns_alias" {
//  value = "${module.ecs-iso.lb_int_dns_alias}"
//}

//# # LB ext
//output "ecs_spg_lb_ext_id" {
//  value = "${module.ecs-iso.lb_ext_id}"
//}
//
//output "ecs_spg_lb_ext_arn" {
//  value = "${module.ecs-iso.lb_ext_arn}"
//}
//
//output "ecs_spg_lb_ext_arn_suffix" {
//  value = "${module.ecs-iso.lb_ext_arn_suffix}"
//}
//
//output "ecs_spg_lb_ext_dns_name" {
//  value = "${module.ecs-iso.lb_ext_dns_name}"
//}
//
//output "ecs_spg_lb_ext_dns_alias" {
//  value = "${module.ecs-iso.lb_ext_dns_alias}"
//}
//

//# TARGET GROUPS int
//output "ecs_spg_int_target_group_id" {
//  value = "${module.ecs-iso.int_target_group_id}"
//}
//
//output "ecs_spg_int_target_group_arn" {
//  value = "${module.ecs-iso.int_target_group_arn}"
//}
//
//output "ecs_spg_int_target_group_arn_suffix" {
//  value = "${module.ecs-iso.int_target_group_arn_suffix}"
//}
//
//output "ecs_spg_int_target_group_name" {
//  value = "${module.ecs-iso.int_target_group_name}"
//}

//# TARGET GROUPS ext
//output "ecs_spg_ext_target_group_id" {
//  value = "${module.ecs-iso.ext_target_group_id}"
//}
//
//output "ecs_spg_ext_target_group_arn" {
//  value = "${module.ecs-iso.ext_target_group_arn}"
//}
//
//output "ecs_spg_ext_target_group_arn_suffix" {
//  value = "${module.ecs-iso.ext_target_group_arn_suffix}"
//}
//
//output "ecs_spg_ext_target_group_name" {
//  value = "${module.ecs-iso.ext_target_group_name}"
//}



//# LISTENER int
//output "ecs_spg_https_lb_int_listener_id" {
//  value = "${module.ecs-iso.https_lb_int_listener_id}"
//}
//
//output "ecs_spg_https_lb_int_listener_arn" {
//  value = "${module.ecs-iso.https_lb_int_listener_arn}"
//}
//
//output "ecs_spg_http_lb_int_listener_id" {
//  value = "${module.ecs-iso.http_lb_int_listener_id}"
//}
//
//output "ecs_spg_http_lb_int_listener_arn" {
//  value = "${module.ecs-iso.http_lb_int_listener_arn}"
//}

# ECS CLUSTER
output "ecs_spg_ecs_cluster_arn" {
  value = "${module.ecs-iso.ecs_cluster_arn}"
}

output "ecs_spg_ecs_cluster_id" {
  value = "${module.ecs-iso.ecs_cluster_id}"
}

output "ecs_spg_ecs_cluster_name" {
  value = "${module.ecs-iso.ecs_cluster_name}"
}

# LOG GROUPS
output "ecs_spg_loggroup_arn" {
  value = "${module.ecs-iso.loggroup_arn}"
}

output "ecs_spg_loggroup_name" {
  value = "${module.ecs-iso.loggroup_name}"
}

# TASK DEFINITION
output "ecs_spg_task_definition_arn" {
  value = "${module.ecs-iso.task_definition_arn}"
}

output "ecs_spg_task_definition_family" {
  value = "${module.ecs-iso.task_definition_family}"
}

output "ecs_spg_task_definition_revision" {
  value = "${module.ecs-iso.task_definition_revision}"
}

# ECS SERVICE
output "ecs_spg_service_id" {
  value = "${module.ecs-iso.ecs_service_id}"
}

output "ecs_spg_service_name" {
  value = "${module.ecs-iso.ecs_service_name}"
}

output "ecs_spg_service_cluster" {
  value = "${module.ecs-iso.ecs_service_cluster}"
}

# Launch config
output "ecs_spg_launch_id" {
  value = "${module.ecs-iso.launch_id}"
}

output "ecs_spg_launch_name" {
  value = "${module.ecs-iso.launch_name}"
}

# ASG
output "autoscale_id" {
  value = "${module.ecs-iso.autoscale_id}"
}

output "ecs_spg_autoscale_arn" {
  value = "${module.ecs-iso.autoscale_arn}"
}

output "ecs_spg_autoscale_name" {
  value = "${module.ecs-iso.autoscale_name}"
}

output "ecs_spg_public_subnet_ids" {
  value = "${module.ecs-iso.public_subnet_ids}"
}

output "ecs_spg_private_subnet_ids" {
  value = "${module.ecs-iso.private_subnet_ids}"
}
