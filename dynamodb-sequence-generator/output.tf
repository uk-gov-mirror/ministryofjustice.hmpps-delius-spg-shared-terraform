output "spgw-mpx-int-ec2.policy" {
  value = "${aws_iam_role_policy_attachment.spgw-mpx-int-ec2.policy_arn}"
}
