#-------------------------------------------------------------
### INTERNAL IAM POLICES FOR ECS SERVICES
#-------------------------------------------------------------

data "template_file" "iam_policy_ecs_crc_int" {
  template = "${file(local.ecs_role_policy_file)}"

  vars {
    aws_lb_arn = "*"
  }
}

module "create-iam-ecs-role-crc-int" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//iam//role"
  rolename   = "${local.common_name}-crc-int-ecs-svc"
  policyfile = "${local.ecs_module_default_assume_role_policy_file}"
}

module "create-iam-ecs-policy-crc-int" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//iam//rolepolicy"
  policyfile = "${data.template_file.iam_policy_ecs_crc_int.rendered}"
  rolename   = "${module.create-iam-ecs-role-crc-int.iamrole_name}"
}


module "create-iam-app-role-crc-int" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//iam//role"
  rolename   = "${local.common_name}-crc-int-ec2"
  policyfile = "${local.ec2_iam_module_default_assume_role_policy_file}"
}

module "create-iam-instance-profile-crc-int" {
  source = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//iam//instance_profile"
  role   = "${module.create-iam-app-role-crc-int.iamrole_name}"
}
