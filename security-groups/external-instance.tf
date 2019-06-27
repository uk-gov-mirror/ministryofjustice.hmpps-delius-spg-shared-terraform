#-------------------------------------------------------------
### external instance sg aka sg_spg_nginx_in
#-------------------------------------------------------------


#-------------------------------------------------------------
### port 8181 (soap/rest/hawtio)
#-------------------------------------------------------------
resource "aws_security_group_rule" "external_inst_egress_httpsigned" {
  description              = "from-iso-to-mpxLB--forHaProxy-8181"
  type                     = "egress"
  security_group_id        = "${local.external_inst_sg_id}"
  source_security_group_id = "${local.internal_lb_sg_id}"
  from_port                = 8181
  to_port                  = 8181
  protocol                 = "tcp"
}




#-------------------------------------------------------------
### port 8989 (soap from iso to mpx)
#-------------------------------------------------------------
resource "aws_security_group_rule" "external_inst_egress_httpunsigned" {
  description              = "from-iso-to-mpxLB--forISOProxy-8989"
  security_group_id        = "${local.external_inst_sg_id}"
  source_security_group_id = "${local.internal_lb_sg_id}"
  type                     = "egress"
  from_port                = 8989
  to_port                  = 8989
  protocol                 = "tcp"
}



#-------------------------------------------------------------
### port 9001 (soap/rest mutual TLS)
#-------------------------------------------------------------

resource "aws_security_group_rule" "external_inst_ingress_https" {
  description              = "from-vpcCIDR-to-iso-for-crc-9001"
  type                     = "ingress"
  cidr_blocks              = ["${local.private_cidr_block}"]  #from crc
  security_group_id        = "${local.external_inst_sg_id}"
  from_port                = 9001
  to_port                  = 9001
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "external_inst_egress_https" {
  description              = "from-iso-to-vpcCIDR-for-crc-9001"
  type                     = "egress"
  security_group_id        = "${local.external_inst_sg_id}"
  cidr_blocks              = ["${local.private_cidr_block}"] #from crc
  from_port                = 9001
  to_port                  = 9001
  protocol                 = "tcp"
}

