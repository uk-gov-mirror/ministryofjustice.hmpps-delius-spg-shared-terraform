#######################################
# SECURITY GROUPS
#######################################
resource "aws_security_group" "spg_common_outbound" {
  name        = "${local.common_name}-spg-common-outbound-sg"
  description = "common egress for ${local.common_name} appliances"
  vpc_id      = "${local.vpc_id}"
  tags        = "${merge(local.tags, map("Name", "${local.common_name}-spg-common-outbound-traffic"))}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "http" {
  security_group_id = "${aws_security_group.spg_common_outbound.id}"
  type              = "egress"
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "http-80-egress"
}

resource "aws_security_group_rule" "all" {
  security_group_id = "${aws_security_group.spg_common_outbound.id}"
  type              = "egress"
  from_port         = "0"
  to_port           = "65535"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "all-ports-egress"
}
