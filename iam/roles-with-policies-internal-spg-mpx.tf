#-------------------------------------------------------------
### INTERNAL IAM POLICES FOR ECS SERVICES
#-------------------------------------------------------------

data "template_file" "iam_policy_ecs_mpx_int" {
  template = file(local.ecs_role_policy_file)

  vars = {
    aws_lb_arn = "*"
  }
}

module "create-iam-ecs-role-mpx-int" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules/iam/role?ref=terraform-0.12"
  rolename   = "${local.common_name}-mpx-int-ecs-svc"
  policyfile = local.ecs_module_default_assume_role_policy_file
}

module "create-iam-ecs-policy-mpx-int" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules/iam/rolepolicy?ref=terraform-0.12"
  policyfile = data.template_file.iam_policy_ecs_mpx_int.rendered
  rolename   = module.create-iam-ecs-role-mpx-int.iamrole_name
}

//overiding role from modules project with extended assumerole permissions for ecs tasks
//resulted in SSM permission failures
module "create-iam-app-role-mpx-int" {
  source     = "../modules/iam/role"
  rolename   = "${local.common_name}-mpx-int-ec2"
  policyfile = local.ec2_iam_module_default_assume_role_policy_file
}

module "create-iam-instance-profile-mpx-int" {
  source = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules/iam/instance_profile?ref=terraform-0.12"
  role   = module.create-iam-app-role-mpx-int.iamrole_name
}

