#-------------------------------------------------------------
### EXTERNAL IAM POLICES FOR ECS SERVICES
#-------------------------------------------------------------

data "template_file" "iam_policy_ecs_ext" {
  template = "${local.ecs_role_policy_file}"

  vars {
    aws_lb_arn = "*"
  }
}

module "create-iam-ecs-role-ext" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//iam//role"
  rolename   = "${local.common_name}-ext-ecs-svc"
  policyfile = "${local.ecs_policy_file}"
}

module "create-iam-ecs-policy-ext" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//iam//rolepolicy"
  policyfile = "${data.template_file.iam_policy_ecs_ext.rendered}"
  rolename   = "${module.create-iam-ecs-role-ext.iamrole_name}"
}

#-------------------------------------------------------------
### EXTERNAL IAM POLICES FOR EC2 RUNNING ECS SERVICES
#-------------------------------------------------------------

data "template_file" "iam_policy_app_ext" {
  template = "${local.ec2_external_policy_file}"

  vars {
    s3-config-bucket   = "${local.s3-config-bucket}"
    app_role_arn       = "${module.create-iam-app-role-ext.iamrole_arn}"
  }
}

module "create-iam-app-role-ext" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//iam//role"
  rolename   = "${local.common_name}-ext-ec2"
  policyfile = "${local.ec2_policy_file}"
}

module "create-iam-instance-profile-ext" {
  source = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//iam//instance_profile"
  role   = "${module.create-iam-app-role-ext.iamrole_name}"
}

module "create-iam-app-policy-ext" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//iam//rolepolicy"
  policyfile = "${data.template_file.iam_policy_app_ext.rendered}"
  rolename   = "${module.create-iam-app-role-ext.iamrole_name}"
}
