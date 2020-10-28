// source security is the range of mpx instances e.g. dlc-sandpit-spgw-sg-outbound-traffic

//Allows https access to the ActiveMQ console via bastion proxy (bastion proxy needs that port in egress)
resource "aws_security_group_rule" "amazonmq_inst_sg_ingress_webconsole" {
  security_group_id = data.terraform_remote_state.vpc-security-groups.outputs.sg_amazonmq_in
  type              = "ingress"
  from_port         = "8162"
  to_port           = "8162"
  protocol          = "tcp"
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  cidr_blocks = values(data.terraform_remote_state.vpc.outputs.bastion_vpc_public_cidr)
  description = "${local.common_name}-instance-amazonmq-sg"
}

//Allows access to the ActiveMQ console from within the SPGW security group
//TODO should cidr blocks below be replaced with  source_security_group_id = "${aws_security_group.spg_common_outbound.id}"
//TODO tf does not match above statement
resource "aws_security_group_rule" "amazonmq_inst_sg_ingress_brokerconsole" {
  security_group_id = data.terraform_remote_state.vpc-security-groups.outputs.sg_amazonmq_in
  type              = "ingress"
  from_port         = "8162"
  to_port           = "8162"
  protocol          = "tcp"
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  cidr_blocks = local.private_cidr_block
  description = "${local.common_name}-instance-amazonmq-sg"
}

//Allows access to the ActiveMQ console from within the SPGW security group
//TODO should cidr blocks below be replaced with  source_security_group_id = "${aws_security_group.spg_common_outbound.id}"
//TODO tf does not match above statement
resource "aws_security_group_rule" "amazonmq_inst_sg_ingress_jms_openwire" {
  security_group_id = data.terraform_remote_state.vpc-security-groups.outputs.sg_amazonmq_in
  type              = "ingress"
  from_port         = "61617"
  to_port           = "61617"
  protocol          = "tcp"
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  cidr_blocks = local.private_cidr_block
  description = "${local.common_name}-instance-amazonmq-sg"
}

