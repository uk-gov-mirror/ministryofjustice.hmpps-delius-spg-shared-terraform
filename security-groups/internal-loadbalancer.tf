
#-------------------------------------------------------------
### internal lb sg aka sg_spg_internal_lb_in
#-------------------------------------------------------------



//8181 for cxf signed soap listener and hawtio from external loadbalancer

resource "aws_security_group_rule" "internal_lb_ingress_http_8181" {
  security_group_id        = "${local.internal_lb_sg_id}"
  type                     = "ingress"
  from_port                = 8181
  to_port                  = 8181
  protocol                 = "tcp"
  source_security_group_id = "${local.external_inst_sg_id}"
  description              = "from-ext-inst-ingress-http-8181"
}


//8181 for internal loadbalancer to innstance
resource "aws_security_group_rule" "internal_lb_egress_http_8181" {
  security_group_id        = "${local.internal_lb_sg_id}"
  type                     = "egress"
  from_port                = 8181
  to_port                  = 8181
  protocol                 = "tcp"
  source_security_group_id = "${local.internal_inst_sg_id}"
  description              = "to-int-inst-engress-http-8181"
}



//8989 for iso to mpx soap proxy (no haproxy)
resource "aws_security_group_rule" "internal_lb_ingress_http_8989" {
  security_group_id        = "${local.internal_lb_sg_id}"
  type                     = "ingress"
  from_port                = 8989
  to_port                  = 8989
  protocol                 = "tcp"
  source_security_group_id = "${local.external_inst_sg_id}"
  description              = "from-ext-inst-ingress-http-8989"
}


//8989 from internal lb to instance
resource "aws_security_group_rule" "internal_lb_egress_http_8989" {
  security_group_id        = "${local.internal_lb_sg_id}"
  type                     = "egress"
  from_port                = 8989
  to_port                  = 8989
  protocol                 = "tcp"
  source_security_group_id = "${local.internal_inst_sg_id}"
  description              = "to-int-inst-ingress-http-8989"
}











## Allow JMS access to SPG GW to from any server in private CIDR block with the port range specified by SPG domain
resource "aws_security_group_rule" "internal_lb_ingress_jms_private" {
  security_group_id        = "${local.internal_lb_sg_id}"
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = "${var.spg_partnergateway_domain_ports["jms_broker"]}"
  to_port                  = "${var.spg_partnergateway_domain_ports["jms_broker_ssl"]}"
  cidr_blocks              = ["${local.private_cidr_block}"]
  description              = "in"
}




//jms from internal loadbalancer to instance
resource "aws_security_group_rule" "internal_lb_egress_jms_61616_7" {
  security_group_id        = "${local.internal_lb_sg_id}"
  type                     = "egress"
  from_port                = "${var.spg_partnergateway_domain_ports["jms_broker"]}"
  to_port                  = "${var.spg_partnergateway_domain_ports["jms_broker_ssl"]}"
  protocol                 = "tcp"
  source_security_group_id = "${local.internal_inst_sg_id}"
  description              = "to-int-inst-ingress-jms-61616"
}
