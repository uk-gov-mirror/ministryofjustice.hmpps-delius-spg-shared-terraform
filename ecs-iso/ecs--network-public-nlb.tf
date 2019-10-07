############################################
# CONTENTS
#
# external network load balancer across 3 AZs, with elastic IPs
# DNS of format spgw-ext.test.delius.probation.hmpps.dsd.io / spgw-ext.sandpit.delius-core.probation.hmpps.dsd.io
# target group hitting backend port 9001 (for tls offloading)
# healthcheck hitting port 8181/cxf
# listener on port 9001 going to target group
#
############################################




############################################
# CREATE EXTERNAL LB FOR spg (iso)
############################################
module "create_app_nlb_ext" {
  //  original source              = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//loadbalancer//alb//create_lb"
  source                    = "../modules/loadbalancer/nlb/create_public_nlb"

  az_lb_eip_allocation_ids  = "${local.az_lb_eip_allocation_ids}"
  internal                  = false
  lb_name                   = "${local.common_name}"
  public_subnet_ids         = "${local.public_subnet_ids}"
  s3_bucket_name            = "${local.access_logs_bucket}"
  tags                      = "${local.tags}"

}



###############################################
# Create route53 entry for spg lb
###############################################

resource "aws_route53_record" "dns_ext_entry" {
  zone_id = "${local.public_zone_id}"
  name    = "${local.application_endpoint}-ext"
  type    = "A"

  alias {
    name                   = "${module.create_app_nlb_ext.lb_dns_name}"
    zone_id                = "${module.create_app_nlb_ext.lb_zone_id}"
    evaluate_target_health = false
  }
}

###strategic - only create if the primary zone id is different to the strategic one
resource "aws_route53_record" "strategic_dns_ext_entry" {
  count = "${(local.public_zone_id == local.strategic_public_zone_id || local.strategic_public_zone_id == "notyetimplemented")  ? 0 : 1}"
  zone_id = "${local.strategic_public_zone_id}"
  name    = "${local.application_endpoint}-ext"
  type    = "A"

  alias {
    name                   = "${module.create_app_nlb_ext.lb_dns_name}"
    zone_id                = "${module.create_app_nlb_ext.lb_zone_id}"
    evaluate_target_health = false
  }
}



############################################
# CREATE INT TARGET GROUPS FOR APP PORTS
############################################

//nlb  target group
module "create_app_nlb_ext_targetgrp" {
  // original source               = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//loadbalancer//alb//targetgroup"
  source               = "../modules/loadbalancer/nlb/targetgroup"
  appname              = "${local.common_name}"
  target_port          = "${local.backend_app_port}"
  target_protocol      = "${local.backend_app_protocol}"
  vpc_id               = "${local.vpc_id}"
  target_type          = "${local.target_type}"
  tags                 = "${local.tags}"
  health_check         = "${local.health_check}"
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




########################################################
# CREATE SECUIRTY RULE FOR ISO instance to listen to NLB
########################################################





###################################################################


data "aws_network_interface" "from_nlb_arn_suffix_per_subnet" {
  count = "${length(local.public_subnet_ids)}"

  filter = {
    name   = "description"
    values = ["ELB ${module.create_app_nlb_ext.lb_arn_suffix}"]
  }

  filter = {
    name   = "subnet-id"
    values = ["${element(local.public_subnet_ids, count.index)}"]
  }
}



#using NLB, have to specify the CIDR blocks that will come through the NLB
#CIDR will include, POs, the LB/VPC

#-------------------------------------------------------------
### port 9001
#-------------------------------------------------------------
resource "aws_security_group_rule" "iso_instance_allports_ingress" {
  security_group_id        = "${data.terraform_remote_state.security-groups-and-rules.iso_external_instance_sg_id}"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  #  protocol          = -1
  cidr_blocks              = ["${formatlist("%s/32",flatten(data.aws_network_interface.from_nlb_arn_suffix_per_subnet.*.private_ips))}"]
  description              = "from NLB"
}