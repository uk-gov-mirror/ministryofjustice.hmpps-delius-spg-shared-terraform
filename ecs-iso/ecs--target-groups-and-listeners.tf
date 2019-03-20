############################################
# CREATE INT TARGET GROUPS FOR APP PORTS
############################################

//nlb  target group
module "create_app_nlb_int_targetgrp" {
  //  source               = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//loadbalancer//alb//targetgroup"
  source               = "../modules/loadbalancer/nlb/targetgroup"
  appname              = "${local.short_environment_name}-${local.app_submodule}-int"
  target_port          = "9001"
  target_protocol      = "TCP"
  vpc_id               = "${local.vpc_id}"
  target_type          = "${local.target_type}"
  tags                 = "${local.tags}"
}




############################################
# CREATE LISTENER(S) FOR APP PORTS
############################################


module "create_app_alb_int_listener_9001" {
  source           = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//loadbalancer//alb//create_listener"
  lb_port          = "9001"
  lb_protocol      = "TCP"
  lb_arn           = "${module.create_app_nlb_int.lb_arn}"
  target_group_arn = "${module.create_app_nlb_int_targetgrp.target_group_arn}"
}

