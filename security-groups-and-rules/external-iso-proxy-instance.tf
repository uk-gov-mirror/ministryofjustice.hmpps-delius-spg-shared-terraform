#-------------------------------------------------------------
### external instance sg aka sg_spg_nginx_in
#-------------------------------------------------------------

//there are no SGs for NLBs so they need to be present here
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
  description = "SPG ISO / HaProxy Instance SG"
  tags        = "${merge(var.tags, map("Name", "${var.environment_name}-${var.spg_app_name}-external-iso-instance", "Type", "WEB"))}"

  lifecycle {
    create_before_destroy = true
  }
}



###################
# EGRESS
###################


#-------------------------------------------------------------
### port 8181 (soap/rest/hawtio) (for when ISO is only doing TLS termination (ie its haproxy) and mpx-hybrid is unsigning)
#-------------------------------------------------------------
resource "aws_security_group_rule" "external_instance_8181_egress" {
  security_group_id        = "${aws_security_group.external_iso_instance.id}"
  description              = "to mpx LB"
  type                     = "egress"
  source_security_group_id = "${aws_security_group.internal_mpx_loadbalancer.id}"
  from_port                = 8181
  to_port                  = 8181
  protocol                 = "tcp"
}



#-------------------------------------------------------------
### port 8989 (unsigned soap from iso to mpx) (for when ISO is only doing TLS termination,  and mpx-hybrid is unsigning)
#-------------------------------------------------------------
resource "aws_security_group_rule" "external_instance_egress_httpunsigned" {
  security_group_id        = "${aws_security_group.external_iso_instance.id}"
  description              = "to mpx LB"
  type                     = "egress"
  source_security_group_id = "${aws_security_group.internal_mpx_loadbalancer.id}"
  from_port                = 8989
  to_port                  = 8989
  protocol                 = "tcp"
}


//all servers can talk on all ports to all ips, so not yet required
//resource "aws_security_group_rule" "external_instance_egress_https" {
//  security_group_id        = "${local.external_inst_sg_id}"
//  description              = "from-iso-to-vpcCIDR-for-crc-9001"
//  type                     = "egress"
//  cidr_blocks              = ["${local.private_cidr_block}"] #from crc
//  from_port                = 9001
//  to_port                  = 9001
//  protocol                 = "tcp"
//}


###################
# INGRESS
###################





#---------------------------------------------------------------------------------------
### port 9001 (soap/rest mutual TLS) from VPC public address for calls from CRC stub
#---------------------------------------------------------------------------------------

resource "aws_security_group_rule" "external_instance_9001_nataz1" {
  security_group_id        = "${aws_security_group.external_iso_instance.id}"
  description              = "from vpcPublicIP AZ1 from crc stub"
  type                     = "ingress"
  cidr_blocks              = ["${local.natgateway_common-nat-public-ip-az1}/32"]  #from crc via public ip
  from_port                = 9001
  to_port                  = 9001
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "external_instance_9001_nataz2" {
  security_group_id        = "${aws_security_group.external_iso_instance.id}"
  description              = "from vpcPublicIP AZ2 from crc stub"
  type                     = "ingress"
  cidr_blocks              = ["${local.natgateway_common-nat-public-ip-az2}/32"]  #from crc via public ip
  from_port                = 9001
  to_port                  = 9001
  protocol                 = "tcp"
}

resource "aws_security_group_rule" "external_instance_9001_nataz3" {
  security_group_id        = "${aws_security_group.external_iso_instance.id}"
  description              = "from vpcPublicIP AZ3 from crc stub"
  type                     = "ingress"
  cidr_blocks              = ["${local.natgateway_common-nat-public-ip-az3}/32"]  #from crc via public ip
  from_port                = 9001
  to_port                  = 9001
  protocol                 = "tcp"
}



#--------------------------------------------------------------------------------------------
# NOTE THERE IS AN ADDITIONAL SECURITY RULE IN ecs-iso/ecs-network-public-nlb.tf that allows
# all traffic from the NLB to the ISO instance
#--------------------------------------------------------------------------------------------

