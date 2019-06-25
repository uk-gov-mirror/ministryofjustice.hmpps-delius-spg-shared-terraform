// source security is the range of mpx instances e.g. dlc-sandpit-spgw-sg-outbound-traffic
resource "aws_security_group_rule" "amazonmq_inst_sg_ingress_ssh_2222" {
  security_group_id        = "${local.amazonmq_inst_sg_id}"
  type                     = "ingress"
  from_port                = "2222"
  to_port                  = "2222"
  protocol                 = "tcp"
  source_security_group_id = "${local.spg_outbound_id}"
  description              = "${local.common_name}-instance-amazonmq-sg"
}

//Allows access to the ActiveMQ console from within the SPGW security group
resource "aws_security_group_rule" "amazonmq_inst_sg_ingress_webconsole" {
  security_group_id        = "${local.amazonmq_inst_sg_id}"
  type                     = "ingress"
  from_port                = "8162"
  to_port                  = "8162"
  protocol                 = "tcp"
  source_security_group_id = "${local.spg_outbound_id}"
  description              = "${local.common_name}-instance-amazonmq-sg"
}

//Allows access to the ActiveMQ console from within the SPGW security group
resource "aws_security_group_rule" "amazonmq_inst_sg_ingress_jms_openwire" {
  security_group_id        = "${local.amazonmq_inst_sg_id}"
  type                     = "ingress"
  from_port                = "61617"
  to_port                  = "61617"
  protocol                 = "tcp"
  source_security_group_id = "${local.spg_outbound_id}"
  description              = "${local.common_name}-instance-amazonmq-sg"
}

