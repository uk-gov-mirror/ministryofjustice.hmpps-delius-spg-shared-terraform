#-------------------------------------------------------------
### external instance sg
#-------------------------------------------------------------



#-------------------------------------------------------------
### port 80
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



resource "aws_security_group_rule" "external_inst_egress_http" {
  security_group_id        = "${local.external_inst_sg_id}"
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = "${local.internal_lb_sg_id}"
  description              = "${local.common_name}-instance-external-egress-http"
}






#-------------------------------------------------------------
### port 443
#-------------------------------------------------------------
resource "aws_security_group_rule" "external_inst_ingress_https" {
  security_group_id        = "${local.external_inst_sg_id}"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = "${local.external_lb_sg_id}"
  description              = "${local.common_name}-instance-external-ingress-https"
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







#-------------------------------------------------------------
### port 9001
#-------------------------------------------------------------
resource "aws_security_group_rule" "external_inst_ingress_mutualtls" {
  security_group_id        = "${local.external_inst_sg_id}"
  type                     = "ingress"
  from_port                = 9001
  to_port                  = 9001
  protocol                 = "tcp"
  source_security_group_id = "${local.external_lb_sg_id}"
  description              = "${local.common_name}-instance-external-ingress-mutualtls"
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





#-------------------------------------------------------------
### port 8989
#-------------------------------------------------------------
resource "aws_security_group_rule" "external_inst_ingress_http-8989" {
  security_group_id        = "${local.external_inst_sg_id}"
  type                     = "ingress"
  from_port                = 8989
  to_port                  = 8989
  protocol                 = "tcp"
  source_security_group_id = "${local.external_lb_sg_id}"
  description              = "${local.common_name}-instance-external-ingress-soapint"
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



