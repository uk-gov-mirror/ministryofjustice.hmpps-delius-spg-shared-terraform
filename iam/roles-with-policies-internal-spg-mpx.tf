#-------------------------------------------------------------
### INTERNAL IAM POLICES FOR ECS SERVICES
#-------------------------------------------------------------

data "template_file" "iam_policy_ecs_mpx_int" {
  template = "${file(local.ecs_role_policy_file)}"

  vars {
    aws_lb_arn = "*"
  }
}

resource "aws_iam_role" "create-iam-ecs-role-mpx-int" {
  name               = "${local.common_name}-mpx-int-ecs-svc-role"
  assume_role_policy = "${file(local.ecs_module_default_assume_role_policy_file)}"
  description        = "${local.common_name}-mpx-int-ecs-svc"
}

resource "aws_iam_role_policy" "create-iam-ecs-policy-mpx-int" {
  name   = "${aws_iam_role.create-iam-ecs-role-mpx-int.name}-policy"
  role   = "${aws_iam_role.create-iam-ecs-role-mpx-int.name}"
  policy = "${data.template_file.iam_policy_ecs_mpx_int.rendered}"
}

resource "aws_iam_role" "create-iam-app-role-mpx-int" {
  name               = "${local.common_name}-mpx-ext-ec2-role"
  assume_role_policy = "${file(local.ec2_iam_module_default_assume_role_policy_file)}"
  description        = "${local.common_name}-mpx-ext-ec2"
}

resource "aws_iam_instance_profile" "create-iam-instance-profile-mpx-int" {
  name = "${aws_iam_role.create-iam-app-role-mpx-int.name}-instance-profile"
  role = "${aws_iam_role.create-iam-app-role-mpx-int.name}"
}

