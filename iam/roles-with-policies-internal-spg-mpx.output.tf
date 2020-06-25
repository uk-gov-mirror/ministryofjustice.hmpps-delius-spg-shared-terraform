####################################################
# IAM - Application specific
####################################################

# INTERNAL

# ECS
output "iam_role_mpx_int_ecs_role_arn" {
  value = "${aws_iam_role.create-iam-ecs-role-mpx-int.arn}"
}

output "iam_role_mpx_int_ecs_role_name" {
  value = "${aws_iam_role.create-iam-ecs-role-mpx-int.name}"
}

# APP ROLE
output "iam_policy_mpx_int_app_role_arn" {
  value = "${aws_iam_role.create-iam-app-role-mpx-int.arn}"
}

output "iam_policy_mpx_int_app_role_name" {
  value = "${aws_iam_role.create-iam-app-role-mpx-int.name}"
}

# PROFILE
output "iam_policy_mpx_int_app_instance_profile_name" {
  value = "${aws_iam_instance_profile.create-iam-instance-profile-mpx-int.name}"
}
