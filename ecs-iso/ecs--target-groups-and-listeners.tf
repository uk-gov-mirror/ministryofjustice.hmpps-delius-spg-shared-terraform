############################################
# CREATE INT TARGET GROUPS FOR APP PORTS
############################################

//nlb  target group
module "create_app_nlb_ext_targetgrp" {
  //  source               = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//loadbalancer//alb//targetgroup"
  source               = "../modules/loadbalancer/nlb/targetgroup"
  appname              = "${local.short_environment_name}-${local.app_submodule}-int"
  target_port          = "${local.backend_app_port}"
  target_protocol      = "${local.backend_app_protocol}"
  vpc_id               = "${local.vpc_id}"
  target_type          = "${local.target_type}"
  tags                 = "${local.tags}"
}




############################################
# CREATE LISTENER(S) FOR APP PORTS
############################################


module "create_app_nlb_ext_listener_9001" {
  source           = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//loadbalancer//alb//create_listener"
  lb_port          = "${local.frontend_app_port}"
  lb_protocol      = "${local.frontend_app_protocol}"
  lb_arn           = "${module.create_app_nlb_ext.lb_arn}"
  target_group_arn = "${module.create_app_nlb_ext_targetgrp.target_group_arn}"
}

