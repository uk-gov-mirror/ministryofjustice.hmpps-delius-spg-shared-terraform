
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
  description              = "${local.common_name}-instance-external-egress-mutualtls"
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



resource "aws_security_group_rule" "external_inst_egress_http-8989" {
  security_group_id        = "${local.external_inst_sg_id}"
  type                     = "egress"
  from_port                = 8989
  to_port                  = 8989
  protocol                 = "tcp"
  source_security_group_id = "${local.internal_lb_sg_id}"
  description              = "${local.common_name}-instance-external-egress-soapint"
}

resource "aws_security_group_rule" "external_inst_ingress_http-8989" {
  security_group_id        = "${local.external_inst_sg_id}"
  type                     = "ingress"
  from_port                = 8989
  to_port                  = 8989
  protocol                 = "tcp"
  source_security_group_id = "${local.external_lb_sg_id}"
  description              = "${local.common_name}-instance-external-ingress-soapint"
}




