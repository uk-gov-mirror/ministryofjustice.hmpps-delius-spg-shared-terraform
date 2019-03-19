####################################################
# DATA SOURCE MODULES FROM OTHER TERRAFORM BACKENDS
####################################################

/*
NOTE - ports 80 & 443 are from original alfresco ports....
port 443 will be useful for hawtio
port 80 inbound should be disabled
*/

####################################################
# Locals
####################################################
locals {
  common_name        = "${var.environment_identifier}-${var.spg_app_name}"
  vpc_id             = "${var.vpc_id}"
  allowed_cidr_block = "${var.allowed_cidr_block}"
  tags               = "${var.tags}"

  public_cidr_block = ["${var.public_cidr_block}"]

  private_cidr_block = ["${var.private_cidr_block}"]

  db_cidr_block       = ["${var.db_cidr_block}"]
  internal_lb_sg_id   = "${var.sg_map_ids["internal_lb_sg_id"]}"
  internal_inst_sg_id = "${var.sg_map_ids["internal_inst_sg_id"]}"
  #  db_sg_id            = "${var.sg_map_ids["db_sg_id"]}"
  external_lb_sg_id   = "${var.sg_map_ids["external_lb_sg_id"]}"
  external_inst_sg_id = "${var.sg_map_ids["external_inst_sg_id"]}"

  weblogic_domain_ports  = "${var.weblogic_domain_ports}"
  spg_partnergateway_domain_ports  = "${var.spg_partnergateway_domain_ports}"
}

#######################################
# SECURITY GROUPS
#######################################




## WOULD IT LOOK LIKE THIS EVENTUALLY Allow JMS access from SPG GW to specific sg
#resource "aws_security_group_rule" "spg_gw_ingress_jms_sg" {
#  security_group_id        = "${local.SPG_BROKER_SG_GROUP}"
#  type                     = "ingress"
#  protocol                 = "tcp"
#  from_port                = "${var.spg_partnergateway_domain_ports["jms_broker"]}"
#  to_port                  = "${var.spg_partnergateway_domain_ports["jms_broker_ssl"]}"
#  source_security_group_id= ["${var.DELIUS_JMS_CONSUMER_SG_GROUP}"]
#  description              = "in"
#}


