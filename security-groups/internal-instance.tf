


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
