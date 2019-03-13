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
#-------------------------------------------------------------
### external lb sg
#-------------------------------------------------------------

//resource "aws_security_group_rule" "external_lb_ingress_http" {
//  security_group_id = "${local.external_lb_sg_id}"
//  from_port         = 80
//  to_port           = 80
//  protocol          = "tcp"
//  type              = "ingress"
//  description       = "${local.common_name}-lb-external-sg-http"
//
//  cidr_blocks = [
//    "${local.allowed_cidr_block}",
//  ]
//}

resource "aws_security_group_rule" "external_lb_ingress_https" {
  security_group_id = "${local.external_lb_sg_id}"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  type              = "ingress"
  description       = "${local.common_name}-lb-external-sg-https"

  cidr_blocks = [
    "${local.allowed_cidr_block}",
  ]
}

//resource "aws_security_group_rule" "external_lb_egress_http" {
//  security_group_id        = "${local.external_lb_sg_id}"
//  type                     = "egress"
//  from_port                = 80
//  to_port                  = 80
//  protocol                 = "tcp"
//  source_security_group_id = "${local.external_inst_sg_id}"
//  description              = "${local.common_name}-instance-internal-http"
//}

resource "aws_security_group_rule" "external_lb_egress_https" {
  security_group_id        = "${local.external_lb_sg_id}"
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = "${local.external_inst_sg_id}"
  description              = "${local.common_name}-instance-internal-https"
}

#-------------------------------------------------------------
### external instance sg
#-------------------------------------------------------------
resource "aws_security_group_rule" "external_inst_ingress_http" {
  security_group_id        = "${local.external_inst_sg_id}"
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = "${local.external_lb_sg_id}"
  description              = "${local.common_name}-instance-external-ingress-http"
}

resource "aws_security_group_rule" "external_inst_ingress_https" {
  security_group_id        = "${local.external_inst_sg_id}"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = "${local.external_lb_sg_id}"
  description              = "${local.common_name}-instance-external-ingress-https"
}

resource "aws_security_group_rule" "external_inst_egress_http" {
  security_group_id        = "${local.external_inst_sg_id}"
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = "${local.internal_lb_sg_id}"
  description              = "${local.common_name}-instance-external-egress-http"
}

resource "aws_security_group_rule" "external_inst_egress_https" {
  security_group_id        = "${local.external_inst_sg_id}"
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = "${local.internal_lb_sg_id}"
  description              = "${local.common_name}-instance-external-egress-https"
}





resource "aws_security_group_rule" "external_inst_egress_mutualtls" {
  security_group_id        = "${local.external_inst_sg_id}"
  type                     = "egress"
  from_port                = 9001
  to_port                  = 9001
  protocol                 = "tcp"
  source_security_group_id = "${local.internal_lb_sg_id}"
  description              = "${local.common_name}-instance-external-egress-https"
}

resource "aws_security_group_rule" "external_inst_ingress_mutualtls" {
  security_group_id        = "${local.external_inst_sg_id}"
  type                     = "ingress"
  from_port                = 9001
  to_port                  = 9001
  protocol                 = "tcp"
  source_security_group_id = "${local.external_lb_sg_id}"
  description              = "${local.common_name}-instance-external-ingress-mutualtls"
}


#-------------------------------------------------------------
### internal lb sg
#-------------------------------------------------------------
resource "aws_security_group_rule" "internal_lb_ingress_http" {
  security_group_id        = "${local.internal_lb_sg_id}"
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = "${local.external_inst_sg_id}"
  description              = "${local.common_name}-lb-ingress-http"
}

resource "aws_security_group_rule" "internal_lb_ingress_http_8181" {
  security_group_id        = "${local.internal_lb_sg_id}"
  type                     = "ingress"
  from_port                = 8181
  to_port                  = 8181
  protocol                 = "tcp"
  source_security_group_id = "${local.external_inst_sg_id}"
  description              = "${local.common_name}-lb-ingress-http"
}



resource "aws_security_group_rule" "internal_lb_ingress_https" {
  security_group_id        = "${local.internal_lb_sg_id}"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = "${local.external_inst_sg_id}"
  description              = "${local.common_name}-lb-ingress-https"
}

resource "aws_security_group_rule" "internal_lb_ingress_mutualtls" {
  security_group_id        = "${local.internal_lb_sg_id}"
  type                     = "ingress"
  from_port                = 9001
  to_port                  = 9001
  protocol                 = "tcp"
  source_security_group_id = "${local.external_inst_sg_id}"
  description              = "${local.common_name}-lb-ingress-https"
}



resource "aws_security_group_rule" "internal_lb_sg_egress_alb_backend_port" {
  security_group_id        = "${local.internal_lb_sg_id}"
  type                     = "egress"
  from_port                = "${var.alb_backend_port}"
  to_port                  = "${var.alb_backend_port}"
  protocol                 = "tcp"
  source_security_group_id = "${local.internal_inst_sg_id}"
  description              = "${local.common_name}"
}

#-------------------------------------------------------------
### internal instance sg
#-------------------------------------------------------------
resource "aws_security_group_rule" "internal_inst_sg_ingress_self" {
  security_group_id = "${local.internal_inst_sg_id}"
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  self              = true
}

resource "aws_security_group_rule" "internal_inst_sg_egress_self" {
  security_group_id = "${local.internal_inst_sg_id}"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  self              = true
}

resource "aws_security_group_rule" "internal_inst_sg_ingress_alb_backend_port" {
  security_group_id        = "${local.internal_inst_sg_id}"
  type                     = "ingress"
  from_port                = "${var.alb_backend_port}"
  to_port                  = "${var.alb_backend_port}"
  protocol                 = "tcp"
  source_security_group_id = "${local.internal_lb_sg_id}"
  description              = "${local.common_name}-instance-internal-sg"
}

resource "aws_security_group_rule" "internal_inst_sg_ingress_alb_http_port" {
  security_group_id        = "${local.internal_inst_sg_id}"
  type                     = "ingress"
  from_port                = "${var.alb_http_port}"
  to_port                  = "${var.alb_http_port}"
  protocol                 = "tcp"
  source_security_group_id = "${local.internal_lb_sg_id}"
  description              = "${local.common_name}-instance-internal-sg"
}



## Allow JMS access from SPG GW to ANY server in private cidr block with the port range specified by delius domain
resource "aws_security_group_rule" "spg_gw_egress_jms_private" {
  security_group_id        = "${local.internal_inst_sg_id}"
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = "${local.weblogic_domain_ports["spg_jms_broker"]}"
  to_port                  = "${local.weblogic_domain_ports["spg_jms_broker_ssl"]}"
  cidr_blocks              = ["${local.private_cidr_block}"]
  description              = "GW to ND JMS"
}



## Allow JMS access to SPG GW to from any server in private CIDR block with the port range specified by SPG domain
resource "aws_security_group_rule" "spg_gw_ingress_jms_private" {
  security_group_id        = "${local.internal_inst_sg_id}"
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = "${var.spg_partnergateway_domain_ports["jms_broker"]}"
  to_port                  = "${var.spg_partnergateway_domain_ports["jms_broker_ssl"]}"
  cidr_blocks              = ["${local.private_cidr_block}"]
  description              = "in"
}

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


