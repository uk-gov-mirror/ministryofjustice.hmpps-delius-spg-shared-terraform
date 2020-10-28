#-------------------------------------------------------------
### Primary CRC LB Security Group
#-------------------------------------------------------------

resource "aws_security_group" "internal_crc_loadbalancer" {
  name        = "${local.common_name}-internal-crc-loadbalancer"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  description = "SPG CRC ELB"
  tags = merge(
    var.tags,
    {
      "Name" = "${var.environment_name}-${var.spg_app_name}-internal-crc-loadbalancer"
      "Type" = "API"
    },
  )

  lifecycle {
    create_before_destroy = true
  }
}

#-------------------------------------------------------------
### port 2222 (ssh as used by MTS tests with virtuoso user)
# TODO should be disabled in non virtuoso envs
#-------------------------------------------------------------
resource "aws_security_group_rule" "crc_lb_2222_from_engineering_ingress" {
  count             = var.is_production ? 0 : 1 # do not allow access if on official data enviro (prod, preprod etc)
  security_group_id = aws_security_group.internal_crc_loadbalancer.id
  description       = "from engineeringNAT for use by virtuoso"
  type              = "ingress"
  cidr_blocks = [
    "${data.terraform_remote_state.engineering_nat.outputs.common-nat-public-ip-az1}/32",
    "${data.terraform_remote_state.engineering_nat.outputs.common-nat-public-ip-az2}/32",
    "${data.terraform_remote_state.engineering_nat.outputs.common-nat-public-ip-az3}/32",
  ]
  from_port = 2222
  to_port   = 2222
  protocol  = "tcp"
}

resource "aws_security_group_rule" "crc_lb_2222_from_mojVPN_ingress" {
  count             = var.is_production ? 0 : 1 # do not allow access if on official data enviro (prod, preprod etc)
  security_group_id = aws_security_group.internal_crc_loadbalancer.id
  description       = "from moj VPN for use by virtuoso"
  type              = "ingress"
  cidr_blocks       = ["81.134.202.29/32"]
  from_port         = 2222
  to_port           = 2222
  protocol          = "tcp"
}

resource "aws_security_group_rule" "crc_lb_2222_from_digital_studio_ingress" {
  count             = var.is_production ? 0 : 1 # do not allow access if on official data enviro (prod, preprod etc)
  security_group_id = aws_security_group.internal_crc_loadbalancer.id
  description       = "from digital studio for use by virtuoso"
  type              = "ingress"
  cidr_blocks       = ["217.33.148.210/32"]
  from_port         = 2222
  to_port           = 2222
  protocol          = "tcp"
}

resource "aws_security_group_rule" "crc_lb_2222_egress" {
  security_group_id        = aws_security_group.internal_crc_loadbalancer.id
  description              = "to crc"
  type                     = "egress"
  source_security_group_id = aws_security_group.internal_crc_instance.id
  from_port                = 2222
  to_port                  = 2222
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "crc_lb_9001_psn_proxy_ingress" {
  count             = length(lookup(var.PO_SPG_FIREWALL_INGRESS_RULES, "PSNPROXY_A", "")) > 0 ? 1 : 0
  security_group_id = aws_security_group.internal_crc_loadbalancer.id
  description       = "from psn proxy"
  type              = "ingress"
  cidr_blocks       = [var.PO_SPG_FIREWALL_INGRESS_RULES["PSNPROXY_A"], var.PO_SPG_FIREWALL_INGRESS_RULES["PSNPROXY_B"]]
  from_port         = 9001
  to_port           = 9001
  protocol          = "tcp"
}

resource "aws_security_group_rule" "crc_lb_to_instance_9001_egress" {
  security_group_id        = aws_security_group.internal_crc_loadbalancer.id
  description              = "lb to crc"
  type                     = "egress"
  source_security_group_id = aws_security_group.internal_crc_instance.id
  from_port                = 9001
  to_port                  = 9001
  protocol                 = "tcp"
}

//the below rules were applicable when crc was internal facing
//and may be required for LB health check
#-------------------------------------------------------------
### port 9001 (soap/rest mutual TLS from spg servers)
### CRC ONLY
#-------------------------------------------------------------
resource "aws_security_group_rule" "crc_lb_9001_ingress" {
  security_group_id = aws_security_group.internal_crc_loadbalancer.id
  description       = "from iso vpc"
  type              = "ingress"
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  cidr_blocks = local.private_cidr_block #from iso / mpx-hybrid servers - TODO should this be a security group instead?
  from_port   = 9001
  to_port     = 9001
  protocol    = "tcp"
}

resource "aws_security_group_rule" "crc_lb_9001_egress" {
  security_group_id = aws_security_group.internal_crc_loadbalancer.id
  description       = "lb to crc"
  type              = "egress"
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  cidr_blocks = local.private_cidr_block # tocrc servers - TODO should this be a secruity group
  from_port   = 9001
  to_port     = 9001
  protocol    = "tcp"
}

