//#-------------------------------------------------------------
//### INTERNAL IAM POLICES FOR EC2 RUNNING ECS SERVICES
//#-------------------------------------------------------------

data "template_file" "iam_policy_app_mpx_int" {
  template = "${file(local.ec2_internal_mpx_policy_file)}"

  vars {
    backups-bucket               = "${local.backups-bucket-name}"
    s3-certificates-bucket       = "${local.s3-certificates-bucket}"
    app_role_arn                 = "${data.terraform_remote_state.iam.iam_policy_mpx_int_app_role_arn}"
    decryptable_certificate_keys = "${jsonencode(local.keys_decrytable_by_mpx)}"
  }
}

module "create-iam-app-policy-mpx-int" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//iam//rolepolicy"
  policyfile = "${data.template_file.iam_policy_app_mpx_int.rendered}"
  rolename   = "${data.terraform_remote_state.iam.iam_policy_mpx_int_app_role_name}"
}
