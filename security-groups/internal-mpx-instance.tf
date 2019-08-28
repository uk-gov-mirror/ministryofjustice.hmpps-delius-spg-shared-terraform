#-------------------------------------------------------------
### internal instance sg aka sg_spg_api_in - for use by mpx/all in one
#-------------------------------------------------------------



# Applicance (MPX / MPX-Hybrid / Mpx-AllInOne)
resource "aws_security_group" "internal_mpx_instance" {
  name        = "${local.common_name}-internal-mpx-instance"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"
  description = "SPG MPX SG"
  tags        = "${merge(var.tags, map("Name", "${var.environment_name}-${var.spg_app_name}-internal-mpx-instance", "Type", "API"))}"

  lifecycle {
    create_before_destroy = true
  }
}

# spg_api_in
output "mpx_instance_sg_id" {
  value = "${aws_security_group.internal_mpx_instance.id}"
}


#-------------------------------------------------------------
### port all (self)
#-------------------------------------------------------------
resource "aws_security_group_rule" "internal_inst_sg_ingress_self" {
  description       = "self"
  self              = true
  security_group_id = "${aws_security_group.internal_mpx_instance.id}"
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
}

resource "aws_security_group_rule" "internal_inst_sg_egress_self" {
  description       = "self"
  security_group_id = "${aws_security_group.internal_mpx_instance.id}"
  self              = true
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
}



#-------------------------------------------------------------
### port 8989
#-------------------------------------------------------------
resource "aws_security_group_rule" "internal_inst_sg_ingress_unsigned_soap" {
  description              = "from-mpxLB-to-mpx-8989"
  type                     = "ingress"
  source_security_group_id = "${aws_security_group.internal_mpx_loadbalancer.id}"
  security_group_id        = "${aws_security_group.internal_mpx_instance.id}"
  from_port                = "8989"
  to_port                  = "8989"
  protocol                 = "tcp"
}

#-------------------------------------------------------------
### port 8181 (soap/rest/hawtio)
#-------------------------------------------------------------
resource "aws_security_group_rule" "internal_inst_sg_ingress_signed_soap" {
  description              = "from-mpxLB-mpx-8181"
  source_security_group_id = "${aws_security_group.internal_mpx_loadbalancer.id}"
  security_group_id        = "${aws_security_group.internal_mpx_instance.id}"
  type                     = "ingress"
  from_port                = "8181"
  to_port                  = "8181"
  protocol                 = "tcp"
}


#-------------------------------------------------------------
### port 2222 (ssh as used by MTS tests with virtuoso user)
#-------------------------------------------------------------
resource "aws_security_group_rule" "internal_inst_sg_ingress_ssh_2222" {
  description              = "from-mpxLB-mpx-2222"
  type                     = "ingress"
  source_security_group_id = "${aws_security_group.internal_mpx_loadbalancer.id}"
  security_group_id        = "${aws_security_group.internal_mpx_instance.id}"
  from_port                = "2222"
  to_port                  = "2222"
  protocol                 = "tcp"
}



#-------------------------------------------------------------
### port 61616-61617 (JMS  nDelius & Alfresco)
#-------------------------------------------------------------
resource "aws_security_group_rule" "internal_inst_ingress_jms_private" {
  description              = "from-mpxLB-mpx-JMS"
  type                     = "ingress"
  source_security_group_id = "${aws_security_group.internal_mpx_loadbalancer.id}"
  security_group_id        = "${aws_security_group.internal_mpx_instance.id}"
  protocol                 = "tcp"
  from_port                = "${var.spg_partnergateway_domain_ports["jms_broker"]}"
  to_port                  = "${var.spg_partnergateway_domain_ports["jms_broker_ssl"]}"
}



## Allow JMS access from SPG to ANY server in private cidr block with the port range specified by delius domain (so includes spg ports as well)
#as of 7/may/2019 there is a generic all ports out bound rule, but this is likely to be reduced
resource "aws_security_group_rule" "internal_inst_egress_jms_private" {
  description              = "from-mpx-to-vpcCIDR-forDeliusLB-and-mpxLBorAmazonMQ-JMS"
  type                     = "egress"
  security_group_id        = "${aws_security_group.internal_mpx_instance.id}"
  cidr_blocks              = ["${local.private_cidr_block}"]
  protocol                 = "tcp"
  from_port                = "${local.weblogic_domain_ports["spg_jms_broker"]}"
  to_port                  = "${local.weblogic_domain_ports["spg_jms_broker_ssl"]}"
}