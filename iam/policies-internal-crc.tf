#-------------------------------------------------------------
### INTERNAL IAM POLICES FOR ECS SERVICES
#-------------------------------------------------------------

data "template_file" "iam_policy_crc_ecs_int" {
  template = "${local.ecs_role_policy_file}"

  vars {
    aws_lb_arn = "*"
  }
}

module "create-iam-crc-ecs-role-int" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//iam//role"
  rolename   = "${local.common_name}-int-crc-ecs-svc"
  policyfile = "${local.ecs_policy_file}"
}

module "create-iam-crc-ecs-policy-int" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//iam//rolepolicy"
  policyfile = "${data.template_file.iam_policy_crc_ecs_int.rendered}"
  rolename   = "${module.create-iam-crc-ecs-role-int.iamrole_name}"
}

#-------------------------------------------------------------
### INTERNAL IAM POLICES FOR EC2 RUNNING ECS SERVICES
#-------------------------------------------------------------

data "template_file" "iam_policy_crc_app_int" {
  template = "${local.ec2_internal_crc_policy_file}"

  vars {
    s3-config-bucket              = "${local.s3-config-bucket}"
    app_role_arn                  = "${module.create-iam-app-role-int.iamrole_arn}"
    backups-bucket                = "${local.environment_identifier}-${local.backups-bucket-name}"
    decryptable_certificate_keys  = "${jsonencode("[

                                     ${data.terraform_remote_state.kms.certificates_spg_crc_cert_kms_arn}]")}"

  }
}

module "create-iam-crc-app-role-int" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//iam//role"
  rolename   = "${local.common_name}-crc-int-ec2"
  policyfile = "${local.ec2_policy_file}"
}

module "create-iam-crc-instance-profile-int" {
  source = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//iam//instance_profile"
  role   = "${module.create-iam-crc-app-role-int.iamrole_name}"
}

module "create-iam-crc-app-policy-int" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//iam//rolepolicy"
  policyfile = "${data.template_file.iam_policy_crc_app_int.rendered}"
  rolename   = "${module.create-iam-crc-app-role-int.iamrole_name}"
}
