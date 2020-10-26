//#-------------------------------------------------------------
//### EXTERNAL IAM POLICES FOR EC2 RUNNING ECS SERVICES
//#-------------------------------------------------------------
//
data "template_file" "iam_policy_app_iso_ext" {
  template = file(local.ec2_external_iso_policy_file)

  vars = {
    backups-bucket               = local.backups-bucket-name
    s3-certificates-bucket       = local.s3-certificates-bucket
    app_role_arn                 = data.terraform_remote_state.iam.outputs.iam_policy_iso_ext_app_role_arn
    decryptable_certificate_keys = jsonencode(local.keys_decrytable_by_iso)
  }
}

module "create-iam-app-policy-iso-ext" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules/iam/rolepolicy?ref=terraform-0.12"
  policyfile = data.template_file.iam_policy_app_iso_ext.rendered
  rolename   = data.terraform_remote_state.iam.outputs.iam_policy_iso_ext_app_role_name
}

