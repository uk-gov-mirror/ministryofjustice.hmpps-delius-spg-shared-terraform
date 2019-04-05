//
//#-------------------------------------------------------------
//### external lb sg aka sg_spg_external_lb_in - there is no LB SG for NLB
//#-------------------------------------------------------------
//
//resource "aws_security_group_rule" "external_lb_ingress_https" {
//  security_group_id = "${local.external_lb_sg_id}"
//  from_port         = 443
//  to_port           = 443
//  protocol          = "tcp"
//  type              = "ingress"
//  description       = "${local.common_name}-lb-external-sg-https"
//
//  cidr_blocks = [
//    "${local.allowed_cidr_block}",
//  ]
//}
//
//
//
//resource "aws_security_group_rule" "external_lb_egress_https" {
//  security_group_id        = "${local.external_lb_sg_id}"
//  type                     = "egress"
//  from_port                = 443
//  to_port                  = 443
//  protocol                 = "tcp"
//  source_security_group_id = "${local.external_inst_sg_id}"
//  description              = "${local.common_name}-instance-internal-https"
//}
//
//
//
//
////resource "aws_security_group_rule" "external_lb_ingress_http" {
////  security_group_id = "${local.external_lb_sg_id}"
////  from_port         = 80
////  to_port           = 80
////  protocol          = "tcp"
////  type              = "ingress"
////  description       = "${local.common_name}-lb-external-sg-http"
////
////  cidr_blocks = [
////    "${local.allowed_cidr_block}",
////  ]
////}
//
//
////resource "aws_security_group_rule" "external_lb_egress_http" {
////  security_group_id        = "${local.external_lb_sg_id}"
////  type                     = "egress"
////  from_port                = 80
////  to_port                  = 80
////  protocol                 = "tcp"
////  source_security_group_id = "${local.external_inst_sg_id}"
////  description              = "${local.common_name}-instance-internal-http"
////}
