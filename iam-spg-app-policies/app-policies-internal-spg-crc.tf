#-------------------------------------------------------------
### INTERNAL IAM POLICES FOR EC2 RUNNING ECS SERVICES
#-------------------------------------------------------------

data "template_file" "iam_policy_app_crc_int" {
  template = "${file(local.ec2_internal_crc_policy_file)}"

  vars {
    s3-certificates-bucket       = "${local.s3-certificates-bucket}"
    app_role_arn                 = "${data.terraform_remote_state.iam.iam_role_crc_int_ecs_role_arn}"
    backups-bucket               = "${local.environment_identifier}-${local.backups-bucket-name}"
    decryptable_certificate_keys = "${jsonencode(local.keys_decrytable_by_crc)}"
  }
}

resource "aws_iam_role_policy" "create-iam-app-policy-crc-int" {
  name   = "${data.terraform_remote_state.iam.iam_policy_crc_int_app_role_name}-policy"
  role   = "${data.terraform_remote_state.iam.iam_policy_crc_int_app_role_name}"
  policy = "${data.template_file.iam_policy_app_crc_int.rendered}"
}
