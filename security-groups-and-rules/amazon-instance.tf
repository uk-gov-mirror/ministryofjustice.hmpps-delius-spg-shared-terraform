// source security is the range of mpx instances e.g. dlc-sandpit-spgw-sg-outbound-traffic

//Allows access to the ActiveMQ console via bastion proxy - TODO this should be SSL
resource "aws_security_group_rule" "amazonmq_inst_sg_ingress_webconsole" {
  security_group_id        = "${data.terraform_remote_state.vpc-security-groups.sg_amazonmq_in}"
  type                     = "ingress"
  from_port                = "8162"
  to_port                  = "8162"
  protocol                 = "tcp"
//  source_security_group_id = "${aws_security_group.spg_common_outbound.id}"
  cidr_blocks             = [ "${values(data.terraform_remote_state.vpc.bastion_vpc_public_cidr)}" ]
  description              = "${local.common_name}-instance-amazonmq-sg"
}

//Allows access to the ActiveMQ console from within the SPGW security group
resource "aws_security_group_rule" "amazonmq_inst_sg_ingress_jms_openwire" {
  security_group_id        = "${data.terraform_remote_state.vpc-security-groups.sg_amazonmq_in}"
  type                     = "ingress"
  from_port                = "61617"
  to_port                  = "61617"
  protocol                 = "tcp"
  cidr_blocks              = ["${local.private_cidr_block}"]
  description              = "${local.common_name}-instance-amazonmq-sg"
}
