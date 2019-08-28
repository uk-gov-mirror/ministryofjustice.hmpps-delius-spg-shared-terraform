#-------------------------------------------------------------
### external instance sg aka sg_spg_nginx_in
#-------------------------------------------------------------

//there are no SGs for NLBs
//resource "aws_security_group" "external_lb_in" {
//  name        = "${local.common_name}-external_lb_in"
//  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"
//  description = "External LB incoming"
//  tags        = "${merge(var.tags, map("Name", "${var.environment_name}_${var.spg_app_name}_external-lb_in_in", "Type", "WEB"))}"
//
//  lifecycle {
//    create_before_destroy = true
//  }
//}



# Applicance (HaProxy or SPG-ISO)
resource "aws_security_group" "external_iso_instance" {
  name        = "${local.common_name}-external-iso-instance"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"
  description = "SPG ISO / HaProxy SG"
  tags        = "${merge(var.tags, map("Name", "${var.environment_name}-${var.spg_app_name}-external-iso-instance", "Type", "WEB"))}"

  lifecycle {
    create_before_destroy = true
  }
}

output "external_iso_instance_sg_id" {
  value = "${aws_security_group.external_iso_instance.id}"
}




#egress rules for ISO instance


#-------------------------------------------------------------
### port 8181 (soap/rest/hawtio) (for when ISO is only doing TLS termination (ie its haproxy) and mpx-hybrid is unsigning)
#-------------------------------------------------------------
resource "aws_security_group_rule" "external_inst_egress_httpsigned" {
  description              = "from-iso-to-mpxLB--forHaProxy-8181"
  type                     = "egress"
  security_group_id        = "${aws_security_group.external_iso_instance.id}"
  source_security_group_id = "${aws_security_group.internal_mpx_loadbalancer.id}"
  from_port                = 8181
  to_port                  = 8181
  protocol                 = "tcp"
}




#-------------------------------------------------------------
### port 8989 (unsigned soap from iso to mpx) (for when ISO is only doing TLS termination,  and mpx-hybrid is unsigning)
#-------------------------------------------------------------
resource "aws_security_group_rule" "external_inst_egress_httpunsigned" {
  description              = "from-iso-to-mpxLB--forISOProxy-8989"
  security_group_id        = "${aws_security_group.external_iso_instance.id}"
  source_security_group_id = "${aws_security_group.internal_mpx_loadbalancer.id}"
  type                     = "egress"
  from_port                = 8989
  to_port                  = 8989
  protocol                 = "tcp"
}



#-------------------------------------------------------------
### port 9001 (soap/rest mutual TLS) from NLB private IP
#-------------------------------------------------------------

resource "aws_security_group_rule" "external_inst_ingress_https_crc_nataz1" {
  description              = "from-vpcNAT-to-iso-for-crc-9001"
  type                     = "ingress"
  cidr_blocks              = ["${local.natgateway_common-nat-public-ip-az1}/32"]  #from crc via NAT
  security_group_id        = "${aws_security_group.external_iso_instance.id}"
  from_port                = 9001
  to_port                  = 9001
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "external_inst_ingress_https_crc_nataz2" {
  description              = "from-vpcNAT-to-iso-for-crc-9001"
  type                     = "ingress"
  cidr_blocks              = ["${local.natgateway_common-nat-public-ip-az2}/32"]  #from crc via NAT
  security_group_id        = "${aws_security_group.external_iso_instance.id}"
  from_port                = 9001
  to_port                  = 9001
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "external_inst_ingress_https_crc_nataz3" {
  description              = "from-vpcNAT-to-iso-for-crc-9001"
  type                     = "ingress"
  cidr_blocks              = ["${local.natgateway_common-nat-public-ip-az3}/32"]  #from crc via NAT
  security_group_id        = "${aws_security_group.external_iso_instance.id}"
  from_port                = 9001
  to_port                  = 9001
  protocol                 = "tcp"
}



//all servers can talk on all ports, so not yet required
//resource "aws_security_group_rule" "external_inst_egress_https" {
//  description              = "from-iso-to-vpcCIDR-for-crc-9001"
//  type                     = "egress"
//  security_group_id        = "${local.external_inst_sg_id}"
//  cidr_blocks              = ["${local.private_cidr_block}"] #from crc
//  from_port                = 9001
//  to_port                  = 9001
//  protocol                 = "tcp"
//}

