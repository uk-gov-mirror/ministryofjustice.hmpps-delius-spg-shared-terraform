####################################################
# IAM - Application specific
####################################################

# INTERNAL

# ECS
output "iam_role_mpx_int_ecs_role_arn" {
  value = "${module.create-iam-ecs-role-mpx-int.iamrole_arn}"
}

output "iam_role_mpx_int_ecs_role_name" {
  value = "${module.create-iam-ecs-role-mpx-int.iamrole_name}"
}

# APP ROLE
output "iam_policy_mpx_int_app_role_arn" {
  value = "${module.create-iam-app-role-mpx-int.iamrole_arn}"
}

output "iam_policy_mpx_int_app_role_name" {
  value = "${module.create-iam-app-role-mpx-int.iamrole_name}"
}

# PROFILE
output "iam_policy_mpx_int_app_instance_profile_name" {
  value = "${module.create-iam-instance-profile-mpx-int.iam_instance_name}"
}
