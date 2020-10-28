####################################################
# Locals
####################################################

locals {
  region                 = var.region
  spg_app_name           = data.terraform_remote_state.common.outputs.spg_app_name
  environment_identifier = data.terraform_remote_state.common.outputs.environment_identifier
  account_id             = data.terraform_remote_state.common.outputs.common_account_id
  common_name            = "${var.environment_identifier}-${var.spg_app_name}"

  ####################################################

  #policies
  ec2_iam_module_default_assume_role_policy_file = "ec2_policy.json"
  ec2_internal_mpx_policy_file                   = "../policies/ec2_mpx_internal_policy.json"
  ec2_internal_crc_policy_file                   = "../policies/ec2_crc_internal_policy.json"
  ec2_external_iso_policy_file                   = "../policies/ec2_iso_external_policy.json"
  ecs_module_default_assume_role_policy_file     = "ecs_policy.json"
  ecs_role_policy_file                           = "../policies/ecs_role_policy.json"
  backups-bucket-name                            = data.terraform_remote_state.common.outputs.common_s3_backups_bucket
  s3-certificates-bucket                         = data.terraform_remote_state.common.outputs.common_engineering_certificates_s3_bucket
  tags = merge(
    var.tags,
    {
      "sub-project" = local.spg_app_name
    },
  )
  keys_decrytable_by_iso = [
    data.terraform_remote_state.kms.outputs.certificates_spg_tls_cert_kms_arn,     //iso always needs tls
    data.terraform_remote_state.kms.outputs.certificates_spg_signing_cert_kms_arn, //iso needs signing certs when acting as signing proxy for mpx (deprecated server-configuration)
  ]
  keys_decrytable_by_mpx = [
    data.terraform_remote_state.kms.outputs.certificates_spg_tls_cert_kms_arn,     //mpx needs tls when sending directly to POs in hybrid / all in one mode
    data.terraform_remote_state.kms.outputs.certificates_spg_signing_cert_kms_arn, //mpx needs signing when sending to POs in hybrid / all in one mode
    data.terraform_remote_state.kms.outputs.certificates_spg_crc_cert_kms_arn,
  ] //mpx needs crc certs when in all in one mode

  //for all in one

  keys_decrytable_by_crc = [
    data.terraform_remote_state.kms.outputs.certificates_spg_crc_cert_kms_arn,
  ]
}

