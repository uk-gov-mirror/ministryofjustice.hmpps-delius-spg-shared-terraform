#-------------------------------------------------------------
### Primary MPX LB Security Group
#-------------------------------------------------------------

resource "aws_security_group" "internal_mpx_loadbalancer" {
  name        = "${local.common_name}-internal-mpx-loadbalancer"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  description = "SPG MPX ELB"
  tags = merge(
    var.tags,
    {
      "Name" = "${var.environment_name}-${var.spg_app_name}-internal-mpx-loadbalancer"
      "Type" = "API"
    },
  )

  lifecycle {
    create_before_destroy = true
  }
}

#INGRESS / EGRESS PAIRS

#-------------------------------------------------------------
### port 8181 (soap/rest/hawtio)
#-------------------------------------------------------------
resource "aws_security_group_rule" "mpx_lb_8181_ingress" {
  security_group_id        = aws_security_group.internal_mpx_loadbalancer.id
  description              = "from iso"
  type                     = "ingress"
  source_security_group_id = aws_security_group.external_iso_instance.id
  from_port                = 8181
  to_port                  = 8181
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "mpx_lb_8181_egress" {
  security_group_id        = aws_security_group.internal_mpx_loadbalancer.id
  description              = "to mpx"
  type                     = "egress"
  source_security_group_id = aws_security_group.internal_mpx_instance.id
  from_port                = 8181
  to_port                  = 8181
  protocol                 = "tcp"
}

#-------------------------------------------------------------
### port 8989 (soap from iso to mpx)
#-------------------------------------------------------------
resource "aws_security_group_rule" "mpx_lb_8989_ingress" {
  security_group_id        = aws_security_group.internal_mpx_loadbalancer.id
  description              = "from iso signing rev-proxy"
  type                     = "ingress"
  source_security_group_id = aws_security_group.external_iso_instance.id
  from_port                = 8989
  to_port                  = 8989
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "mpx_lb_8989_egress" {
  security_group_id        = aws_security_group.internal_mpx_loadbalancer.id
  description              = "to mpx"
  type                     = "egress"
  source_security_group_id = aws_security_group.internal_mpx_instance.id
  from_port                = 8989
  to_port                  = 8989
  protocol                 = "tcp"
}

//#-------------------------------------------------------------
//### port 2222 (ssh as used by MTS tests with virtuoso user)
//#-------------------------------------------------------------
//resource "aws_security_group_rule" "mpx_lb_2222_ingress" {
//  security_group_id        = "${aws_security_group.internal_mpx_loadbalancer.id}"
//  description              = "from engineeringCIDR for use by virtuoso"
//  type                     = "ingress"
//  cidr_blocks              = ["${data.terraform_remote_state.vpc.eng_vpc_cidr}"]
//  from_port                = 2222
//  to_port                  = 2222
//  protocol                 = "tcp"
//}
//
//
//resource "aws_security_group_rule" "mpx_lb_2222_egress" {
//  security_group_id        = "${aws_security_group.internal_mpx_loadbalancer.id}"
//  description              = "to mpx"
//  type                     = "egress"
//  source_security_group_id = "${aws_security_group.internal_mpx_instance.id}"
//  from_port                = 2222
//  to_port                  = 2222
//  protocol                 = "tcp"
//}

#-------------------------------------------------------------
### port 61616-61617 (JMS  nDelius & Alfresco)
#-------------------------------------------------------------
resource "aws_security_group_rule" "mpx_lb_jms_ingress" {
  security_group_id = aws_security_group.internal_mpx_loadbalancer.id
  description       = "from vpc CIDR from ND, ALF, MPX"
  type              = "ingress"
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  cidr_blocks = local.private_cidr_block
  protocol    = "tcp"
  from_port   = var.spg_partnergateway_domain_ports["jms_broker"]
  to_port     = var.spg_partnergateway_domain_ports["jms_broker_ssl"]
}

resource "aws_security_group_rule" "mpx_lb_jms_egress" {
  security_group_id        = aws_security_group.internal_mpx_loadbalancer.id
  description              = "to mpx"
  source_security_group_id = aws_security_group.internal_mpx_instance.id
  type                     = "egress"
  from_port                = var.spg_partnergateway_domain_ports["jms_broker"]
  to_port                  = var.spg_partnergateway_domain_ports["jms_broker_ssl"]
  protocol                 = "tcp"
}

