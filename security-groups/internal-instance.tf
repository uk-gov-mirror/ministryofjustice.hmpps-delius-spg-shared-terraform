


#-------------------------------------------------------------
### internal instance sg aka sg_spg_api_in - for use by mpx/all in one
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

//for when allinone.iso calls allinone.mpx via loadbalancer
resource "aws_security_group_rule" "internal_inst_sg_ingress_unsigned_soap" {
  security_group_id        = "${local.internal_inst_sg_id}"
  type                     = "ingress"
  from_port                = "8989"
  to_port                  = "8989"
  protocol                 = "tcp"
  source_security_group_id = "${local.internal_lb_sg_id}"
  description              = "${local.common_name}-instance-internal-sg"
}

//for when iso/haproxy calls mpx via loadbalancer
resource "aws_security_group_rule" "internal_inst_sg_ingress_signed_soap" {
  security_group_id        = "${local.internal_inst_sg_id}"
  type                     = "ingress"
  from_port                = "8181"
  to_port                  = "8181"
  protocol                 = "tcp"
  source_security_group_id = "${local.internal_lb_sg_id}"
  description              = "${local.common_name}-instance-internal-sg"
}





## Allow JMS access from SPG GW to ANY server in private cidr block with the port range specified by delius domain
resource "aws_security_group_rule" "internal_inst_egress_jms_private" {
  security_group_id        = "${local.internal_lb_sg_id}"
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = "${local.weblogic_domain_ports["spg_jms_broker"]}"
  to_port                  = "${local.weblogic_domain_ports["spg_jms_broker_ssl"]}"
  cidr_blocks              = ["${local.private_cidr_block}"]
  description              = "GW to ND JMS"
}