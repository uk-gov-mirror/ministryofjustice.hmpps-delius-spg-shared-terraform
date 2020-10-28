#-------------------------------------------------------------
### EXTERNAL IAM POLICES FOR ECS SERVICES
#-------------------------------------------------------------

data "template_file" "iam_policy_ecs_ext" {
  template = file(local.ecs_role_policy_file)

  vars = {
    aws_lb_arn = "*"
  }
}

module "create-iam-ecs-role-iso-ext" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules/iam/role?ref=terraform-0.12"
  rolename   = "${local.common_name}-iso-ext-ecs-svc"
  policyfile = local.ecs_module_default_assume_role_policy_file
}

module "create-iam-ecs-policy-iso-ext" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules/iam/rolepolicy?ref=terraform-0.12"
  policyfile = data.template_file.iam_policy_ecs_ext.rendered
  rolename   = module.create-iam-ecs-role-iso-ext.iamrole_name
}

//overide role from modules project with extended assumerole permissions for ecs tasks
module "create-iam-app-role-iso-ext" {
  source     = "../modules/iam/role"
  rolename   = "${local.common_name}-iso-ext-ec2"
  policyfile = local.ec2_iam_module_default_assume_role_policy_file
}

module "create-iam-instance-profile-iso-ext" {
  source = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules/iam/instance_profile?ref=terraform-0.12"
  role   = module.create-iam-app-role-iso-ext.iamrole_name
}

