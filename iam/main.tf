####################################################
# Locals
####################################################

locals {
  region                 = var.region
  spg_app_name           = data.terraform_remote_state.common.outputs.spg_app_name
  environment_identifier = data.terraform_remote_state.common.outputs.environment_identifier
  account_id             = data.terraform_remote_state.common.outputs.common_account_id

  ####################################################
  ### workaround for training-test exceeding 64 chars
  ### the original logic was to use local.environment_identifier for all envs except DTT, which used local.short_environment_identifier
  ###
  ### However, tf_short_environment_identifier was changed by another ALS project for that environment and so caused breakages.
  ### The logic now uses historic_dtt_prefix as a fixed value

  historic_dtt_prefix            = "tf-dtt-training-test"
  dynamic_environment_identifier = local.environment_identifier == "tf-eu-west-2-hmpps-delius-training-test" ? local.historic_dtt_prefix : local.environment_identifier
  common_name                    = "${local.dynamic_environment_identifier}-${var.spg_app_name}"

  ####################################################

  #policies
  ec2_iam_module_default_assume_role_policy_file = "ec2_policy.json"
  ec2_internal_mpx_policy_file                   = "../policies/ec2_mpx_internal_policy.json"
  ec2_internal_crc_policy_file                   = "../policies/ec2_crc_internal_policy.json"
  ec2_external_iso_policy_file                   = "../policies/ec2_iso_external_policy.json"
  ecs_module_default_assume_role_policy_file     = "ecs_policy.json"
  ecs_role_policy_file                           = "../policies/ecs_role_policy.json"
  backups-bucket-name                            = var.backups-bucket-name
  s3-certificates-bucket                         = data.terraform_remote_state.common.outputs.common_engineering_certificates_s3_bucket
  tags = merge(
    var.tags,
    {
      "sub-project" = local.spg_app_name
    },
  )
}

