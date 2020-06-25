####################################################
# IAM - Application specific
####################################################

# INTERNAL

# ECS
output "iam_role_crc_int_ecs_role_arn" {
  value = "${aws_iam_role.create-iam-ecs-role-crc-int.arn}"
}

output "iam_role_crc_int_ecs_role_name" {
  value = "${aws_iam_role.create-iam-ecs-role-crc-int.name}"
}

# APP ROLE
output "iam_policy_crc_int_app_role_arn" {
  value = "${aws_iam_role.create-iam-app-role-crc-int.arn}"
}

output "iam_policy_crc_int_app_role_name" {
  value = "${aws_iam_role.create-iam-app-role-crc-int.name}"
}

# PROFILE
output "iam_policy_crc_int_app_instance_profile_name" {
  value = "${aws_iam_instance_profile.create-iam-instance-profile-crc-int.name}"
}
