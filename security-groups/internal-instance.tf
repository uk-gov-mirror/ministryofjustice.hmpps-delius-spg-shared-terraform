


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
  description       = "self"
}

resource "aws_security_group_rule" "internal_inst_sg_egress_self" {
  security_group_id = "${local.internal_inst_sg_id}"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  self              = true
  description       = "self"
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


//for when automation tests ssh in via loadbalancer...makes sense for single instance groups, multi instance will resolve randomly to an instance
resource "aws_security_group_rule" "internal_inst_sg_ingress_ssh_2222" {
  security_group_id        = "${local.internal_inst_sg_id}"
  type                     = "ingress"
  from_port                = "2222"
  to_port                  = "2222"
  protocol                 = "tcp"
  source_security_group_id = "${local.internal_lb_sg_id}"
  description              = "${local.common_name}-instance-internal-sg"
}



## Allow JMS access to SPG GW from loadbalancer
resource "aws_security_group_rule" "internal_inst_ingress_jms_private" {
  security_group_id        = "${local.internal_inst_sg_id}"
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = "${var.spg_partnergateway_domain_ports["jms_broker"]}"
  to_port                  = "${var.spg_partnergateway_domain_ports["jms_broker_ssl"]}"
  source_security_group_id = "${local.internal_lb_sg_id}"
  description              = "JMS in from lb"
}



## Allow JMS access from SPG to ANY server in private cidr block with the port range specified by delius domain (so includes spg ports as well)
#as of 7/may/2019 there is a generic all ports out bound rule, but this is likely to be reduced
resource "aws_security_group_rule" "internal_inst_egress_jms_private" {
  security_group_id        = "${local.internal_inst_sg_id}"
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = "${local.weblogic_domain_ports["spg_jms_broker"]}"
  to_port                  = "${local.weblogic_domain_ports["spg_jms_broker_ssl"]}"
  cidr_blocks              = ["${local.private_cidr_block}"]
  description              = "JMS out to GW to ND JMS"
}