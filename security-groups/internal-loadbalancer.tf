
#-------------------------------------------------------------
### internal lb sg aka sg_spg_internal_lb_in
#-------------------------------------------------------------



//8181 for cxf signed soap listener and hawtio

resource "aws_security_group_rule" "internal_lb_ingress_http_8181" {
  security_group_id        = "${local.internal_lb_sg_id}"
  type                     = "ingress"
  from_port                = 8181
  to_port                  = 8181
  protocol                 = "tcp"
  source_security_group_id = "${local.external_inst_sg_id}"
  description              = "from-ext-inst-ingress-http-8181"
}



resource "aws_security_group_rule" "internal_lb_egress_http_8181" {
  security_group_id        = "${local.internal_lb_sg_id}"
  type                     = "egress"
  from_port                = 8181
  to_port                  = 8181
  protocol                 = "tcp"
  source_security_group_id = "${local.internal_inst_sg_id}"
  description              = "to-int-inst-engress-http-8181"
}



//8989 for iso to mpx soap proxy

resource "aws_security_group_rule" "internal_lb_ingress_http_8989" {
  security_group_id        = "${local.internal_lb_sg_id}"
  type                     = "ingress"
  from_port                = 8989
  to_port                  = 8989
  protocol                 = "tcp"
  source_security_group_id = "${local.external_inst_sg_id}"
  description              = "from-ext-inst-ingress-http-8989"
}



resource "aws_security_group_rule" "internal_lb_egress_http_8989" {
  security_group_id        = "${local.internal_lb_sg_id}"
  type                     = "egress"
  from_port                = 8989
  to_port                  = 8989
  protocol                 = "tcp"
  source_security_group_id = "${local.internal_inst_sg_id}"
  description              = "to-int-inst-ingress-http-8989"
}




//internal jms

resource "aws_security_group_rule" "internal_lb_ingress_jms_61616" {
  security_group_id        = "${local.internal_lb_sg_id}"
  type                     = "ingress"
  from_port                = 61616
  to_port                  = 61616
  protocol                 = "tcp"
  source_security_group_id = "${local.external_inst_sg_id}"
  description              = "from-ext-inst-ingress-jms-61616"
}





resource "aws_security_group_rule" "internal_lb_egress_jms_61616" {
  security_group_id        = "${local.internal_lb_sg_id}"
  type                     = "egress"
  from_port                = 61616
  to_port                  = 61616
  protocol                 = "tcp"
  source_security_group_id = "${local.internal_inst_sg_id}"
  description              = "to-int-inst-ingress-jms-61616"
}
