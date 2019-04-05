
############################################
# CREATE INTERNAL LB FOR spg (mpx)
############################################


module "create_app_elb" {
  #  source          = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//loadbalancer//elb//create_elb"
  # requires provider 2.1.6
  source          = "../modules/loadbalancer/elb/create_elb"
  name            = "${local.common_name}-elb"
  subnets         = ["${local.private_subnet_ids}"]
  security_groups = ["${local.int_lb_security_groups}"]
  internal        = "true"

  cross_zone_load_balancing   = "true"
  idle_timeout                = "${local.backend_timeout}"
  connection_draining         = "${local.connection_draining}"
  connection_draining_timeout = "${local.connection_draining_timeout}"
  bucket                      = "${local.access_logs_bucket}"
  bucket_prefix               = "${local.common_name}-elb"
  interval                    = 60
  listener                    = ["${local.listener}"]
  health_check                = ["${local.health_check_elb}"]

  tags = "${local.tags}"
}



###############################################
# Create INTERNAL route53 entry for spg lb
###############################################

resource "aws_route53_record" "dns_int_entry" {
  zone_id = "${local.public_zone_id}"
  name    = "${local.application_endpoint}-${local.app_submodule}-int.${local.external_domain}"
  type    = "A"

  alias {
    name                   = "${module.create_app_elb.environment_elb_dns_name}"
    zone_id                = "${module.create_app_elb.environment_elb_zone_id}"
    evaluate_target_health = false
  }
}


############################################
# CREATE INT TARGET GROUPS FOR APP PORTS
############################################

//nlb  target group
module "create_app_elb_int_targetgrp" {
  //  source               = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//loadbalancer//alb//targetgroup"
  source               = "../modules/loadbalancer/nlb/targetgroup"
  appname              = "${local.common_name}-int"
  target_port          = "${local.backend_app_port}"
  target_protocol      = "${local.backend_app_protocol}"
  vpc_id               = "${local.vpc_id}"
  target_type          = "${local.target_type}"
  tags                 = "${local.tags}"
  health_check         = "${local.health_check_tg}"
}

