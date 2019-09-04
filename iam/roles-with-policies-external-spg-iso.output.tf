####################################################
# IAM - Application specific
####################################################
# EXTERNAL

# ECS
output "iam_role_iso_ext_ecs_role_arn" {
  value = "${module.create-iam-ecs-role-iso-ext.iamrole_arn}"
}

output "iam_role_iso_ext_ecs_role_name" {
  value = "${module.create-iam-ecs-role-iso-ext.iamrole_name}"
}

# APP ROLE
output "iam_policy_iso_ext_app_role_arn" {
  value = "${module.create-iam-app-role-iso-ext.iamrole_arn}"
}

output "iam_policy_iso_ext_app_role_name" {
  value = "${module.create-iam-app-role-iso-ext.iamrole_name}"
}

# PROFILE
output "iam_policy_iso_ext_app_instance_profile_name" {
  value = "${module.create-iam-instance-profile-iso-ext.iam_instance_name}"
}
