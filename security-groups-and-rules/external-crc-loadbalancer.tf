#-------------------------------------------------------------
### Primary CRC LB Security Group
#-------------------------------------------------------------


resource "aws_security_group" "internal_crc_loadbalancer" {
  name        = "${local.common_name}-internal-crc-loadbalancer"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"
  description = "SPG CRC ELB"
  tags        = "${merge(var.tags, map("Name", "${var.environment_name}-${var.spg_app_name}-internal-crc-loadbalancer", "Type", "API"))}"

  lifecycle {
    create_before_destroy = true
  }
}








#-------------------------------------------------------------
### port 2222 (ssh as used by MTS tests with virtuoso user)
# TODO should be disabled in non virtuoso envs
#-------------------------------------------------------------
resource "aws_security_group_rule" "crc_lb_2222_ingress" {
  security_group_id        = "${aws_security_group.internal_crc_loadbalancer.id}"
  description              = "from engineeringCIDR for use by virtuoso"
  type                     = "ingress"
  cidr_blocks              = ["${data.terraform_remote_state.vpc.eng_vpc_cidr}"]
  from_port                = 2222
  to_port                  = 2222
  protocol                 = "tcp"
}


resource "aws_security_group_rule" "crc_lb_2222_egress" {
  security_group_id        = "${aws_security_group.internal_crc_loadbalancer.id}"
  description              = "to crc"
  type                     = "egress"
  source_security_group_id = "${aws_security_group.internal_crc_instance.id}"
  from_port                = 2222
  to_port                  = 2222
  protocol                 = "tcp"
}




resource "aws_security_group_rule" "crc_lb_9001_psn_proxy_ingress" {
  count                   = "${(length(lookup(var.PO_SPG_FIREWALL_INGRESS_RULES, "PSNPROXY_A","") )>0) ? 1 : 0}"
  security_group_id        = "${aws_security_group.internal_crc_loadbalancer.id}"
  description              = "from psn proxy"
  type                     = "ingress"
    cidr_blocks              = ["${lookup(var.PO_SPG_FIREWALL_INGRESS_RULES,"PSNPROXY_A")}","${lookup(var.PO_SPG_FIREWALL_INGRESS_RULES,"PSNPROXY_B")}"]
  from_port                = 9001
  to_port                  = 9001
  protocol                 = "tcp"
}



resource "aws_security_group_rule" "crc_lb_to_instance_9001_egress" {
  security_group_id = "${aws_security_group.internal_crc_loadbalancer.id}"
  description = "lb to crc"
  type = "egress"
  source_security_group_id = "${aws_security_group.internal_crc_instance.id}"
  from_port = 9001
  to_port = 9001
  protocol = "tcp"
}

//the below rules were applicable when crc was internal facing
//and may be required for LB health check
#-------------------------------------------------------------
### port 9001 (soap/rest mutual TLS from spg servers)
### CRC ONLY
#-------------------------------------------------------------
resource "aws_security_group_rule" "crc_lb_9001_ingress" {
  security_group_id        = "${aws_security_group.internal_crc_loadbalancer.id}"
  description              = "from iso vpc"
  type                     = "ingress"
  cidr_blocks              = ["${local.private_cidr_block}"]  #from iso / mpx-hybrid servers - TODO should this be a security group instead?
  from_port                = 9001
  to_port                  = 9001
  protocol                 = "tcp"
}


resource "aws_security_group_rule" "crc_lb_9001_egress" {
  security_group_id        = "${aws_security_group.internal_crc_loadbalancer.id}"
  description              = "lb to crc"
  type                     = "egress"
  cidr_blocks              = ["${local.private_cidr_block}"]  # tocrc servers - TODO should this be a secruity group
  from_port                = 9001
  to_port                  = 9001
  protocol                 = "tcp"
}
