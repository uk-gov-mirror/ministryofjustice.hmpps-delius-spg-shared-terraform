//
//# TODO move this group to network level, so other appliances can use rules
//resource "aws_security_group" "vpc_ingress" {
//  name        = "${local.common_name}-vpc-ingress"
//  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"
//  description = "Rules to allow POs and proxies into SPG enabled appliances"
//  tags        = "${merge(var.tags, map("Name", "${var.environment_name}-parent-orgs-spg-ingress", "Type", "WEB"))}"
//
//  lifecycle {
//    create_before_destroy = true
//  }
//}
//
//
//
//
//
//###################
//# INGRESS
//###################
//
//
//
//
//resource "aws_security_group_rule" "vpc_ingress" {
//
//  security_group_id        = "${aws_security_group.vpc_ingress.id}"
//  description              = "TF_VPC INGRESS"
//  type                     = "ingress"
//  cidr_blocks              = ["${element(values(var.PO_SPG_FIREWALL_INGRESS_RULES),count.index)}"]
//  from_port                = "${var.PO_SPG_FIREWALL_INGRESS_PORT}"
//  to_port                  = "${var.PO_SPG_FIREWALL_INGRESS_PORT}"
//  protocol                 = "tcp"
//}
//
//
//
//
//
//
