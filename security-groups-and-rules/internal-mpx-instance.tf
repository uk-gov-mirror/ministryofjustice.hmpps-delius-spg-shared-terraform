#-------------------------------------------------------------
### internal instance sg aka sg_spg_api_in - for use by mpx/all in one
#-------------------------------------------------------------



# Applicance (MPX / MPX-Hybrid / Mpx-AllInOne)
resource "aws_security_group" "internal_mpx_instance" {
  name        = "${local.common_name}-internal-mpx-instance"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"
  description = "SPG MPX Instance SG"
  tags        = "${merge(var.tags, map("Name", "${var.environment_name}-${var.spg_app_name}-internal-mpx-instance", "Type", "API"))}"

  lifecycle {
    create_before_destroy = true
  }
}



#-------------------------------------------------------------
### INGRESS + EGRESS PAIRS
#-------------------------------------------------------------
resource "aws_security_group_rule" "mpx_instance_self_ingress" {
  security_group_id = "${aws_security_group.internal_mpx_instance.id}"
  description       = "self"
  self              = true
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
}

resource "aws_security_group_rule" "mpx_instance_self_egress" {
  security_group_id = "${aws_security_group.internal_mpx_instance.id}"
  description       = "self"
  self              = true
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
}




###################
# EGRESS ONLY
###################


## Allow JMS access from SPG to ANY server in private cidr block with the port range specified by delius domain (so includes spg ports as well)
#as of 7/may/2019 there is a generic all ports out bound rule, but this is likely to be reduced
resource "aws_security_group_rule" "mpx_instance_egress_jms_private" {
  security_group_id        = "${aws_security_group.internal_mpx_instance.id}"
  description              = "to vpcCIDR forDeliusLB and mpx LB orAmazonMQ-JMS"
  type                     = "egress"
  cidr_blocks              = ["${local.private_cidr_block}"]
  protocol                 = "tcp"
  from_port                = "${local.weblogic_domain_ports["spg_jms_broker"]}"
  to_port                  = "${local.weblogic_domain_ports["spg_jms_broker_ssl"]}"
}



###################
# INGRESS ONLY
###################


#-------------------------------------------------------------
### port 8989 unsigned soap
#-------------------------------------------------------------
resource "aws_security_group_rule" "mpx_instance_8989_ingress" {
  security_group_id        = "${aws_security_group.internal_mpx_instance.id}"
  description              = "from mpx LB"
  type                     = "ingress"
  source_security_group_id = "${aws_security_group.internal_mpx_loadbalancer.id}"
  from_port                = "8989"
  to_port                  = "8989"
  protocol                 = "tcp"
}

#-------------------------------------------------------------
### port 8181 (soap/rest/hawtio)
#-------------------------------------------------------------
resource "aws_security_group_rule" "mpx_instance_8181_ingress" {
  security_group_id        = "${aws_security_group.internal_mpx_instance.id}"
  description              = "from mpx LB"
  type                     = "ingress"
  source_security_group_id = "${aws_security_group.internal_mpx_loadbalancer.id}"
  from_port                = "8181"
  to_port                  = "8181"
  protocol                 = "tcp"
}


//#-------------------------------------------------------------
//### port 2222 (ssh as used by MTS tests with virtuoso user)
//# TODO this should be removed now that crc has its own LB rules
//#-------------------------------------------------------------
//resource "aws_security_group_rule" "mpx_instance_2222_ingress" {
//  security_group_id        = "${aws_security_group.internal_mpx_instance.id}"
//  description              = "from mpx LB"
//  type                     = "ingress"
//  source_security_group_id = "${aws_security_group.internal_mpx_loadbalancer.id}"
//  from_port                = "2222"
//  to_port                  = "2222"
//  protocol                 = "tcp"
//}



#-------------------------------------------------------------
### port 61616-61617 (JMS  nDelius & Alfresco)
#-------------------------------------------------------------
resource "aws_security_group_rule" "mpx_instance_jms_ingress" {
  security_group_id        = "${aws_security_group.internal_mpx_instance.id}"
  description              = "from mpx LB"
  type                     = "ingress"
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.internal_mpx_loadbalancer.id}"
  from_port                = "${var.spg_partnergateway_domain_ports["jms_broker"]}"
  to_port                  = "${var.spg_partnergateway_domain_ports["jms_broker_ssl"]}"
}



