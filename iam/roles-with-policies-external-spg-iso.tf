#-------------------------------------------------------------
### EXTERNAL IAM POLICES FOR ECS SERVICES
#-------------------------------------------------------------

data "template_file" "iam_policy_ecs_ext" {
  template = "${file(local.ecs_role_policy_file)}"

  vars {
    aws_lb_arn = "*"
  }
}

resource "aws_iam_role" "create-iam-ecs-role-iso-ext" {
  name               = "${local.common_name}-iso-ext-ecs-svc-role"
  assume_role_policy = "${file(local.ecs_module_default_assume_role_policy_file)}"
  description        = "${local.common_name}-iso-ext-ecs-svc"
}


resource "aws_iam_role_policy" "create-iam-ecs-policy-iso-ext" {
  name   = "${aws_iam_role.create-iam-ecs-role-iso-ext.name}-policy"
  role   = "${aws_iam_role.create-iam-ecs-role-iso-ext.name}"
  policy = "${data.template_file.iam_policy_ecs_ext.rendered}"
}


resource "aws_iam_role" "create-iam-app-role-iso-ext" {
  name               = "${local.common_name}-iso-ext-ec2-role"
  assume_role_policy = "${file(local.ec2_iam_module_default_assume_role_policy_file)}"
  description        = "${local.common_name}-iso-ext-ec2"
}


resource "aws_iam_instance_profile" "create-iam-instance-profile-iso-ext" {
  name = "${aws_iam_role.create-iam-app-role-iso-ext.name}-instance-profile"
  role = "${aws_iam_role.create-iam-app-role-iso-ext.name}"
}

