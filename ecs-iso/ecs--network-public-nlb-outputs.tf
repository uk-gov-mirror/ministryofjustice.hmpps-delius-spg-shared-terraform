output "lb_arn_suffix" {
  description = "The name of the ELB"
  value       = "${module.create_app_nlb_ext.lb_arn_suffix}"
}


output "target_group_arn_suffix" {
  description = "The name of the ELB"
  value       = "${module.create_app_nlb_ext_targetgrp.target_group_arn_suffix}"
}


