#-------------------------------------------------------------
### INTERNAL IAM POLICES FOR ECS SERVICES
#-------------------------------------------------------------

data "template_file" "iam_policy_ecs_crc_int" {
  template = "${file(local.ecs_role_policy_file)}"

  vars {
    aws_lb_arn = "*"
  }
}

resource "aws_iam_role" "create-iam-ecs-role-crc-int" {
  name               = "${local.common_name}-crc-int-ecs-svc-role"
  assume_role_policy = "${file(local.ecs_module_default_assume_role_policy_file)}"
  description        = "${local.common_name}-crc-int-ecs-svc"
}


resource "aws_iam_role_policy" "create-iam-ecs-policy-crc-int" {
  name   = "${aws_iam_role.create-iam-ecs-role-crc-int.name}-policy"
  role   = "${aws_iam_role.create-iam-ecs-role-crc-int.name}"
  policy = "${data.template_file.iam_policy_ecs_crc_int.rendered}"
}


resource "aws_iam_role" "create-iam-app-role-crc-int" {
  name               = "${local.common_name}-crc-int-ec2-role"
  assume_role_policy = "${file(local.ecs_module_default_assume_role_policy_file)}"
  description        = "${local.common_name}-crc-int-ec2"
}

resource "aws_iam_instance_profile" "create-iam-instance-profile-crc-int" {
  name = "${aws_iam_role.create-iam-app-role-crc-int.name}-instance-profile"
  role = "${aws_iam_role.create-iam-app-role-crc-int.name}"
}
