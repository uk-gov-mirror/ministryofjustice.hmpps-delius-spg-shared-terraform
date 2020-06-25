####################################################
# IAM - Application specific
####################################################
# EXTERNAL

# ECS
output "iam_role_iso_ext_ecs_role_arn" {
  value = "${aws_iam_role.create-iam-ecs-role-iso-ext.arn}"
}

output "iam_role_iso_ext_ecs_role_name" {
  value = "${aws_iam_role.create-iam-ecs-role-iso-ext.name}"
}

# APP ROLE
output "iam_policy_iso_ext_app_role_arn" {
  value = "${aws_iam_role.create-iam-app-role-iso-ext.arn}"
}

output "iam_policy_iso_ext_app_role_name" {
  value = "${aws_iam_role.create-iam-app-role-iso-ext.name}"
}

# PROFILE
output "iam_policy_iso_ext_app_instance_profile_name" {
  value = "${aws_iam_instance_profile.create-iam-instance-profile-iso-ext.name}"
}
