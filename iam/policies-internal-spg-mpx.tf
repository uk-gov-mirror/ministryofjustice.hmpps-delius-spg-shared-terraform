#-------------------------------------------------------------
### INTERNAL IAM POLICES FOR ECS SERVICES
#-------------------------------------------------------------

data "template_file" "iam_policy_ecs_mpx_int" {
  template = "${file(local.ecs_role_policy_file)}"

  vars {
    aws_lb_arn = "*"
  }
}

module "create-iam-ecs-role-mpx-int" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//iam//role"
  rolename   = "${local.common_name}-mpx-int-ecs-svc"
  policyfile = "${local.ecs_module_default_assume_role_policy_file}"
}

module "create-iam-ecs-policy-mpx-int" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//iam//rolepolicy"
  policyfile = "${data.template_file.iam_policy_ecs_mpx_int.rendered}"
  rolename   = "${module.create-iam-ecs-role-mpx-int.iamrole_name}"
}

#-------------------------------------------------------------
### INTERNAL IAM POLICES FOR EC2 RUNNING ECS SERVICES
#-------------------------------------------------------------

data "template_file" "iam_policy_app_mpx_int" {
  template = "${file(local.ec2_internal_mpx_policy_file)}"

  vars {
    s3-config-bucket       = "${local.s3-config-bucket}"
    s3-certificates-bucket = "${local.s3-certificates-bucket}"
    app_role_arn           = "${module.create-iam-app-role-mpx-int.iamrole_arn}"
    backups-bucket         = "${local.environment_identifier}-${local.backups-bucket-name}"

    decryptable_certificate_keys  = [
      "${data.terraform_remote_state.kms.certificates_spg_iso_cert_kms_id}",
      "${data.terraform_remote_state.kms.certificates_spg_mpx_cert_kms_id}",

    ]


    //    decryptable_certificate_keys  = "${jsonencode("[
    //                                     ${data.terraform_remote_state.kms.certificates_spg_cert_kms_arn},
    //                                     ${data.terraform_remote_state.kms.certificates_spg_crc_cert_kms_arn}]")}"
  }
}

module "create-iam-app-role-mpx-int" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//iam//role"
  rolename   = "${local.common_name}-mpx-int-ec2"
  policyfile = "${local.ec2_iam_module_default_assume_role_policy_file}"
}

module "create-iam-instance-profile-mpx-int" {
  source = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//iam//instance_profile"
  role   = "${module.create-iam-app-role-mpx-int.iamrole_name}"
}

module "create-iam-app-policy-mpx-int" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//iam//rolepolicy"
  policyfile = "${data.template_file.iam_policy_app_mpx_int.rendered}"
  rolename   = "${module.create-iam-app-role-mpx-int.iamrole_name}"
}
