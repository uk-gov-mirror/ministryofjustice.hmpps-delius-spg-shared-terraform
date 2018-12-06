# LB int
output "lb_int_id" {
  value = "${module.create_app_alb_int.lb_id}"
}

output "lb_int_arn" {
  value = "${module.create_app_alb_int.lb_arn}"
}

output "lb_int_arn_suffix" {
  value = "${module.create_app_alb_int.lb_arn_suffix}"
}

output "lb_int_dns_name" {
  value = "${module.create_app_alb_int.lb_dns_name}"
}

output "lb_int_dns_alias" {
  value = "${aws_route53_record.dns_int_entry.fqdn}"
}

output "public_subnet_ids" {
  value = "${local.public_subnet_ids}"
}


output "private_subnet_ids" {
  value = "${local.private_subnet_ids}"
}

//
//# LB ext
//output "lb_ext_id" {
//  value = "${module.create_app_alb_ext.lb_id}"
//}
//
//output "lb_ext_arn" {
//  value = "${module.create_app_alb_ext.lb_arn}"
//}
//
//output "lb_ext_arn_suffix" {
//  value = "${module.create_app_alb_ext.lb_arn_suffix}"
//}
//
//output "lb_ext_dns_name" {
//  value = "${module.create_app_alb_ext.lb_dns_name}"
//}
//
//output "lb_ext_dns_alias" {
//  value = "${aws_route53_record.dns_ext_entry.fqdn}"
//}



# LISTENER int
output "https_lb_int_listener_id" {
  value = "${element(module.create_app_alb_int_listener.listener_id,0)}"
}

output "https_lb_int_listener_arn" {
  value = "${element(module.create_app_alb_int_listener.listener_arn,0)}"
}

output "http_lb_int_listener_id" {
  value = "${element(module.create_app_alb_int_listener.listener_id,0)}"
}

output "http_lb_int_listener_arn" {
  value = "${element(module.create_app_alb_int_listener.listener_arn,0)}"
}

//# LISTENER ext
//output "https_lb_ext_listener_id" {
//  value = "${element(module.create_app_alb_ext_listener.listener_id,0)}"
//}
//
//output "https_lb_ext_listener_arn" {
//  value = "${element(module.create_app_alb_ext_listener.listener_arn,0)}"
//}
//
//output "http_lb_ext_listener_id" {
//  value = "${element(module.create_app_alb_ext_listener.listener_id,0)}"
//}
//
//output "http_lb_ext_listener_arn" {
//  value = "${element(module.create_app_alb_ext_listener.listener_arn,0)}"
//}




# TARGET GROUPS int
output "int_target_group_id" {
  value = "${module.create_app_alb_int_targetgrp.target_group_id}"
}

output "int_target_group_arn" {
  value = "${module.create_app_alb_int_targetgrp.target_group_arn}"
}

output "int_target_group_arn_suffix" {
  value = "${module.create_app_alb_int_targetgrp.target_group_arn_suffix}"
}

output "int_target_group_name" {
  value = "${module.create_app_alb_int_targetgrp.target_group_name}"
}

//# TARGET GROUPS ext
//output "ext_target_group_id" {
//  value = "${module.create_app_alb_ext_targetgrp.target_group_id}"
//}
//
//output "ext_target_group_arn" {
//  value = "${module.create_app_alb_ext_targetgrp.target_group_arn}"
//}
//
//output "ext_target_group_arn_suffix" {
//  value = "${module.create_app_alb_ext_targetgrp.target_group_arn_suffix}"
//}
//
//output "ext_target_group_name" {
//  value = "${module.create_app_alb_ext_targetgrp.target_group_name}"
//}

# ECS CLUSTER
output "ecs_cluster_arn" {
  value = "${module.ecs_cluster.ecs_cluster_arn}"
}

output "ecs_cluster_id" {
  value = "${module.ecs_cluster.ecs_cluster_id}"
}

output "ecs_cluster_name" {
  value = "${module.ecs_cluster.ecs_cluster_name}"
}

# LOG GROUPS
output "loggroup_arn" {
  value = "${module.create_loggroup.loggroup_arn}"
}

output "loggroup_name" {
  value = "${module.create_loggroup.loggroup_name}"
}

# TASK DEFINITION
output "task_definition_arn" {
  value = "${module.app_task_definition.task_definition_arn}"
}

output "task_definition_family" {
  value = "${module.app_task_definition.task_definition_family}"
}

output "task_definition_revision" {
  value = "${module.app_task_definition.task_definition_revision}"
}

# ECS SERVICE
output "ecs_service_id" {
  value = "${module.app_service.ecs_service_id}"
}

output "ecs_service_name" {
  value = "${module.app_service.ecs_service_name}"
}

output "ecs_service_cluster" {
  value = "${module.app_service.ecs_service_cluster}"
}

# Launch config
output "launch_id" {
  value = "${module.launch_cfg.launch_id}"
}

output "launch_name" {
  value = "${module.launch_cfg.launch_name}"
}

# ASG
output "autoscale_id" {
  value = "${module.auto_scale.autoscale_id}"
}

output "autoscale_arn" {
  value = "${module.auto_scale.autoscale_arn}"
}

output "autoscale_name" {
  value = "${module.auto_scale.autoscale_name}"
}
