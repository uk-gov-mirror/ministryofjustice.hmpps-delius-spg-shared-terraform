
#-------------------------------------------------------------
### internal lb sg
#-------------------------------------------------------------


resource "aws_security_group_rule" "internal_lb_ingress_mutualtls" {
  security_group_id        = "${local.internal_lb_sg_id}"
  type                     = "ingress"
  from_port                = 9001
  to_port                  = 9001
  protocol                 = "tcp"
  source_security_group_id = "${local.external_inst_sg_id}"
  description              = "${local.common_name}-lb-ingress-mutualtls-9001"
}




resource "aws_security_group_rule" "internal_lb_ingress_http_8181" {
  security_group_id        = "${local.internal_lb_sg_id}"
  type                     = "ingress"
  from_port                = 8181
  to_port                  = 8181
  protocol                 = "tcp"
  source_security_group_id = "${local.external_inst_sg_id}"
  description              = "${local.common_name}-lb-ingress-http-8181"
}


resource "aws_security_group_rule" "internal_lb_ingress_http_8989" {
  security_group_id        = "${local.internal_lb_sg_id}"
  type                     = "ingress"
  from_port                = 8989
  to_port                  = 8989
  protocol                 = "tcp"
  source_security_group_id = "${local.external_inst_sg_id}"
  description              = "${local.common_name}-lb-ingress-http-8989"
}





resource "aws_security_group_rule" "internal_lb_ingress_jms_61616" {
  security_group_id        = "${local.internal_lb_sg_id}"
  type                     = "ingress"
  from_port                = 61616
  to_port                  = 61616
  protocol                 = "tcp"
  source_security_group_id = "${local.external_inst_sg_id}"
  description              = "${local.common_name}-lb-ingress-jms-61616"
}







resource "aws_security_group_rule" "internal_lb_sg_egress_alb_backend_port" {
  security_group_id        = "${local.internal_lb_sg_id}"
  type                     = "egress"
  from_port                = "${var.alb_backend_port}"
  to_port                  = "${var.alb_backend_port}"
  protocol                 = "tcp"
  source_security_group_id = "${local.internal_inst_sg_id}"
  description              = "${local.common_name}"
}








