################################################################################
## spg_perf
################################################################################
resource "aws_security_group" "spg_perf" {
  name        = "${var.environment_name}-spg-perf"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"
  description = "spg perf egress rules"
  tags        = "${merge(var.tags, map("Name", "${var.environment_name}-spg-perf", "Type", "SPG Egress Rules"))}"

  lifecycle {
    create_before_destroy = true
  }
}

output "sg_spg_perf_id" {
  value = "${aws_security_group.spg_perf.id}"
}

# This is a temp solution to enable quick access to yum repos from dev env
# during discovery.
resource "aws_security_group_rule" "spg_perf_80" {
  security_group_id = "${aws_security_group.spg_perf.id}"
  type              = "egress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "tmp yum repos git docker"
}

# This is a temp solution to enable quick access to S3 bucket from dev env
# during discovery.
resource "aws_security_group_rule" "spg_perf_443" {
  security_group_id = "${aws_security_group.spg_perf.id}"
  type              = "egress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "tmp s3"
}

# Allow access to SPG
resource "aws_security_group_rule" "spg_perf_9001" {
  security_group_id = "${aws_security_group.spg_perf.id}"
  type              = "egress"
  protocol          = "tcp"
  from_port         = 9001
  to_port           = 9001
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "SPG port"
}
