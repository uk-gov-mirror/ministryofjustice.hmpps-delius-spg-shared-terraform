#-------------------------------------------------------------
### internal instance sg aka sg_spg_api_in - for use by crc/all in one
#-------------------------------------------------------------

# Applicance (CRC / CRC-Hybrid / Mpx-AllInOne)
resource "aws_security_group" "internal_crc_instance" {
  name        = "${local.common_name}-internal-crc-instance"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  description = "SPG CRC Instance SG"
  tags = merge(
    var.tags,
    {
      "Name" = "${var.environment_name}-${var.spg_app_name}-internal-crc-instance"
      "Type" = "API"
    },
  )

  lifecycle {
    create_before_destroy = true
  }
}

#-------------------------------------------------------------
### INGRESS + EGRESS PAIRS
#-------------------------------------------------------------
resource "aws_security_group_rule" "crc_instance_self_ingress" {
  security_group_id = aws_security_group.internal_crc_instance.id
  description       = "self"
  self              = true
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
}

resource "aws_security_group_rule" "crc_instance_self_egress" {
  security_group_id = aws_security_group.internal_crc_instance.id
  description       = "self"
  self              = true
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
}

###################
# INGRESS ONLY
###################

#-------------------------------------------------------------
### port 8181 (healthcheck) - would be better as port 443
#-------------------------------------------------------------
resource "aws_security_group_rule" "crc_instance_8181_ingress" {
  security_group_id        = aws_security_group.internal_crc_instance.id
  description              = "from crc LB"
  type                     = "ingress"
  source_security_group_id = aws_security_group.internal_crc_loadbalancer.id
  from_port                = "8181"
  to_port                  = "8181"
  protocol                 = "tcp"
}

#-------------------------------------------------------------
### port 9001
#-------------------------------------------------------------
resource "aws_security_group_rule" "crc_instance_9001_ingress" {
  security_group_id        = aws_security_group.internal_crc_instance.id
  description              = "from crc LB"
  type                     = "ingress"
  source_security_group_id = aws_security_group.internal_crc_loadbalancer.id
  from_port                = "9001"
  to_port                  = "9001"
  protocol                 = "tcp"
}

#-------------------------------------------------------------
### port 2222 (ssh as used by MTS tests with virtuoso user)
# TODO should be disabled in non virtuoso envs
#-------------------------------------------------------------
resource "aws_security_group_rule" "crc_instance_2222_ingress" {
  security_group_id        = aws_security_group.internal_crc_instance.id
  description              = "from crc LB"
  type                     = "ingress"
  source_security_group_id = aws_security_group.internal_crc_loadbalancer.id
  from_port                = "2222"
  to_port                  = "2222"
  protocol                 = "tcp"
}

