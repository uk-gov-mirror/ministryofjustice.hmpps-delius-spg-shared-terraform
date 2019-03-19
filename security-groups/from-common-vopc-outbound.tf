#######################################
# SECURITY GROUPS
#######################################
resource "aws_security_group" "vpc-sg-outbound" {
  name        = "${local.common_name}-sg-outbound"
  description = "security group for ${local.common_name}-traffic"
  vpc_id      = "${local.vpc_id}"
  tags        = "${merge(local.tags, map("Name", "${local.common_name}-outbound-traffic"))}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "http" {
  security_group_id = "${aws_security_group.vpc-sg-outbound.id}"
  type              = "egress"
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "${local.common_name}-http"
}

resource "aws_security_group_rule" "all" {
  security_group_id = "${aws_security_group.vpc-sg-outbound.id}"
  type              = "egress"
  from_port         = "0"
  to_port           = "65535"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "${local.common_name}-all"
}
