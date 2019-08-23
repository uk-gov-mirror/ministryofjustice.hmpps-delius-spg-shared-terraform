
#-------------------------------------------------------------
### internal lb sg aka sg_spg_internal_lb_in
#-------------------------------------------------------------




#-------------------------------------------------------------
### port 8181 (soap/rest/hawtio)
#-------------------------------------------------------------
resource "aws_security_group_rule" "internal_lb_ingress_http_8181" {
  description              = "from-iso-to-mpxLB-8181"
  type                     = "ingress"
  source_security_group_id = "${local.external_inst_sg_id}"
  security_group_id        = "${local.internal_lb_sg_id}"
  from_port                = 8181
  to_port                  = 8181
  protocol                 = "tcp"
}


resource "aws_security_group_rule" "internal_lb_egress_http_8181" {
  description              = "from-mpxLB-to-mpx-8181"
  type                     = "egress"
  security_group_id        = "${local.internal_lb_sg_id}"
  source_security_group_id = "${local.internal_inst_sg_id}"
  from_port                = 8181
  to_port                  = 8181
  protocol                 = "tcp"
}



#-------------------------------------------------------------
### port 8989 (soap from iso to mpx)
#-------------------------------------------------------------
resource "aws_security_group_rule" "internal_lb_ingress_http_8989" {
  description              = "from-iso-to-mpxLB-8989"
  type                     = "ingress"
  source_security_group_id = "${local.external_inst_sg_id}"
  security_group_id        = "${local.internal_lb_sg_id}"
  from_port                = 8989
  to_port                  = 8989
  protocol                 = "tcp"
}



resource "aws_security_group_rule" "internal_lb_egress_http_8989" {
  description              = "from-mpxLB-to-mpx-8181"
  type                     = "egress"
  security_group_id        = "${local.internal_lb_sg_id}"
  source_security_group_id = "${local.internal_inst_sg_id}"
  from_port                = 8989
  to_port                  = 8989
  protocol                 = "tcp"
}



#-------------------------------------------------------------
### port 2222 (ssh as used by MTS tests with virtuoso user)
#-------------------------------------------------------------
resource "aws_security_group_rule" "internal_lb_ingress_ssh_2222" {
  description              = "from-engineeringCIDR-to-mpxLB-2222"
  type                     = "ingress"
  cidr_blocks              = ["${data.terraform_remote_state.vpc.eng_vpc_cidr}"]
  security_group_id        = "${local.internal_lb_sg_id}"
  from_port                = 2222
  to_port                  = 2222
  protocol                 = "tcp"
}


resource "aws_security_group_rule" "internal_lb_egress_ssh_2222" {
  description              = "from-mpxLB-to-mpx-2222"
  type                     = "egress"
  security_group_id        = "${local.internal_lb_sg_id}"
  source_security_group_id = "${local.internal_inst_sg_id}"
  from_port                = 2222
  to_port                  = 2222
  protocol                 = "tcp"
}



#-------------------------------------------------------------
### port 61616-61617 (JMS  nDelius & Alfresco)
### MPX / HYBRID ONLY
#-------------------------------------------------------------
resource "aws_security_group_rule" "internal_lb_ingress_jms_private" {
  description              = "from-vpcCIDR-to-mpxLB-JMS"
  type                     = "ingress"
  cidr_blocks              = ["${local.private_cidr_block}"]
  security_group_id        = "${local.internal_lb_sg_id}"
  protocol                 = "tcp"
  from_port                = "${var.spg_partnergateway_domain_ports["jms_broker"]}"
  to_port                  = "${var.spg_partnergateway_domain_ports["jms_broker_ssl"]}"
}




resource "aws_security_group_rule" "internal_lb_egress_jms_61616_7" {
  description              = "from-mpxLB-to-mpx-JMS"
  source_security_group_id = "${local.internal_inst_sg_id}"
  security_group_id        = "${local.internal_lb_sg_id}"
  type                     = "egress"
  from_port                = "${var.spg_partnergateway_domain_ports["jms_broker"]}"
  to_port                  = "${var.spg_partnergateway_domain_ports["jms_broker_ssl"]}"
  protocol                 = "tcp"
}






#-------------------------------------------------------------
### port 9001 (soap/rest mutual TLS)
### CRC ONLY
#-------------------------------------------------------------
resource "aws_security_group_rule" "internal_lb_ingress_https" {
  description              = "from-iso-to-crcLB-9001"
  type                     = "ingress"
  cidr_blocks              = ["${local.private_cidr_block}"]  #for iso & mpx-hybrid servers (actually all servers in private all)
  security_group_id        = "${local.internal_lb_sg_id}"
  from_port                = 9001
  to_port                  = 9001
  protocol                 = "tcp"
}


resource "aws_security_group_rule" "internal_lb_egress_https" {
  description              = "from-crcLB-to-crc-9001"
  type                     = "egress"
  security_group_id        = "${local.internal_lb_sg_id}"
  cidr_blocks              = ["${local.private_cidr_block}"]  # for crc servers
  from_port                = 9001
  to_port                  = 9001
  protocol                 = "tcp"
}
