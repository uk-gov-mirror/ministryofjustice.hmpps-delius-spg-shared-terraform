# # LB int
//output "ecs_spg_lb_int_id" {
//  value = "${module.ecs-mpx.lb_int_id}"
//}
//
//output "ecs_spg_lb_int_arn" {
//  value = "${module.ecs-mpx.lb_int_arn}"
//}
//
//output "ecs_spg_lb_int_arn_suffix" {
//  value = "${module.ecs-mpx.lb_int_arn_suffix}"
//}
//
//output "ecs_spg_lb_int_dns_name" {
//  value = "${module.ecs-mpx.lb_int_dns_name}"
//}
//
//output "ecs_spg_lb_int_dns_alias" {
//  value = "${module.ecs-mpx.lb_int_dns_alias}"
//}

//# # LB ext
//output "ecs_spg_lb_ext_id" {
//  value = "${module.ecs-mpx.lb_ext_id}"
//}
//
//output "ecs_spg_lb_ext_arn" {
//  value = "${module.ecs-mpx.lb_ext_arn}"
//}
//
//output "ecs_spg_lb_ext_arn_suffix" {
//  value = "${module.ecs-mpx.lb_ext_arn_suffix}"
//}
//
//output "ecs_spg_lb_ext_dns_name" {
//  value = "${module.ecs-mpx.lb_ext_dns_name}"
//}
//
//output "ecs_spg_lb_ext_dns_alias" {
//  value = "${module.ecs-mpx.lb_ext_dns_alias}"
//}
//

//# TARGET GROUPS int
//output "ecs_spg_int_target_group_id" {
//  value = "${module.ecs-mpx.int_target_group_id}"
//}
//
//output "ecs_spg_int_target_group_arn" {
//  value = "${module.ecs-mpx.int_target_group_arn}"
//}
//
//output "ecs_spg_int_target_group_arn_suffix" {
//  value = "${module.ecs-mpx.int_target_group_arn_suffix}"
//}
//
//output "ecs_spg_int_target_group_name" {
//  value = "${module.ecs-mpx.int_target_group_name}"
//}

//# TARGET GROUPS ext
//output "ecs_spg_ext_target_group_id" {
//  value = "${module.ecs-mpx.ext_target_group_id}"
//}
//
//output "ecs_spg_ext_target_group_arn" {
//  value = "${module.ecs-mpx.ext_target_group_arn}"
//}
//
//output "ecs_spg_ext_target_group_arn_suffix" {
//  value = "${module.ecs-mpx.ext_target_group_arn_suffix}"
//}
//
//output "ecs_spg_ext_target_group_name" {
//  value = "${module.ecs-mpx.ext_target_group_name}"
//}



//# LISTENER int
//output "ecs_spg_https_lb_int_listener_id" {
//  value = "${module.ecs-mpx.https_lb_int_listener_id}"
//}
//
//output "ecs_spg_https_lb_int_listener_arn" {
//  value = "${module.ecs-mpx.https_lb_int_listener_arn}"
//}
//
//output "ecs_spg_http_lb_int_listener_id" {
//  value = "${module.ecs-mpx.http_lb_int_listener_id}"
//}
//
//output "ecs_spg_http_lb_int_listener_arn" {
//  value = "${module.ecs-mpx.http_lb_int_listener_arn}"
//}


output "ecs_spg_public_subnet_ids" {
  value = "${local.public_subnet_ids}"
}

output "ecs_spg_private_subnet_ids" {
  value = "${local.private_subnet_ids}"
}
