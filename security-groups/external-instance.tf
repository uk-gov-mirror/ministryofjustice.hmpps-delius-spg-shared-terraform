#-------------------------------------------------------------
### external instance sg aka sg_spg_nginx_in
#-------------------------------------------------------------


//webports not used for nginx / haproxy
//#-------------------------------------------------------------
//### port 80
//#-------------------------------------------------------------
//resource "aws_security_group_rule" "external_inst_ingress_http" {
//  security_group_id        = "${local.external_inst_sg_id}"
//  type                     = "ingress"
//  from_port                = 80
//  to_port                  = 80
//  protocol                 = "tcp"
//  source_security_group_id = "${local.external_lb_sg_id}"
//  description              = "${local.common_name}-instance-external-ingress-http"
//}
//
//
//
//resource "aws_security_group_rule" "external_inst_egress_http" {
//  security_group_id        = "${local.external_inst_sg_id}"
//  type                     = "egress"
//  from_port                = 80
//  to_port                  = 80
//  protocol                 = "tcp"
//  source_security_group_id = "${local.internal_lb_sg_id}"
//  description              = "${local.common_name}-instance-external-egress-http"
//}
//
//
//
//
//
//
//#-------------------------------------------------------------
//### port 443
//#-------------------------------------------------------------
//resource "aws_security_group_rule" "external_inst_ingress_https" {
//  security_group_id        = "${local.external_inst_sg_id}"
//  type                     = "ingress"
//  from_port                = 443
//  to_port                  = 443
//  protocol                 = "tcp"
//  source_security_group_id = "${local.external_lb_sg_id}"
//  description              = "${local.common_name}-instance-external-ingress-https"
//}
//
//resource "aws_security_group_rule" "external_inst_egress_https" {
//  security_group_id        = "${local.external_inst_sg_id}"
//  type                     = "egress"
//  from_port                = 443
//  to_port                  = 443
//  protocol                 = "tcp"
//  source_security_group_id = "${local.internal_lb_sg_id}"
//  description              = "${local.common_name}-instance-external-egress-https"
//}








// egress is 8181 from haproxy to mpx-lb (all in one)
resource "aws_security_group_rule" "external_inst_egress_httpsigned" {
  security_group_id        = "${local.external_inst_sg_id}"
  type                     = "egress"
  from_port                = 8181
  to_port                  = 8181
  protocol                 = "tcp"
  source_security_group_id = "${local.internal_lb_sg_id}"
  description              = "${local.common_name}-instance-external-egress-httpsigned"
}

// egress is 8989 from iso to mpx-lb
resource "aws_security_group_rule" "external_inst_egress_httpunsigned" {
  security_group_id        = "${local.external_inst_sg_id}"
  type                     = "egress"
  from_port                = 8989
  to_port                  = 8989
  protocol                 = "tcp"
  source_security_group_id = "${local.internal_lb_sg_id}"
  description              = "${local.common_name}-instance-external-egress-httpunsigned"
}




//port 8989 not exposed on external
//#-------------------------------------------------------------
//### port 8989
//#-------------------------------------------------------------
//resource "aws_security_group_rule" "external_inst_ingress_http-8989" {
//  security_group_id        = "${local.external_inst_sg_id}"
//  type                     = "ingress"
//  from_port                = 8989
//  to_port                  = 8989
//  protocol                 = "tcp"
//  source_security_group_id = "${local.external_lb_sg_id}"
//  description              = "${local.common_name}-instance-external-ingress-soapint"
//}
//
//
//resource "aws_security_group_rule" "external_inst_egress_http-8989" {
//  security_group_id        = "${local.external_inst_sg_id}"
//  type                     = "egress"
//  from_port                = 8989
//  to_port                  = 8989
//  protocol                 = "tcp"
//  source_security_group_id = "${local.internal_lb_sg_id}"
//  description              = "${local.common_name}-instance-external-egress-soapint"
//}



//workaround for terraform unable to get private IPs of NLB  as of 04/04/2019
//there is a pull request waiting to fix this https://github.com/terraform-providers/terraform-provider-aws/pull/2901
//hava put the rule in the main iso project
