terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

provider "aws" {
  region = "${var.region}"
  version = "~> 1.16"
}

####################################################
# DATA SOURCE MODULES FROM OTHER TERRAFORM BACKENDS
####################################################

####################################################
# Locals
####################################################

locals {
  tags = "${var.tags}"

  roles_allowed_to_decrypt_spg_tls = [
    "${data.terraform_remote_state.iam.iam_policy_iso_ext_app_role_arn}",
    "${data.terraform_remote_state.iam.iam_policy_mpx_int_app_role_arn}"]

  roles_allowed_to_decrypt_spg_signing = [
    "${data.terraform_remote_state.iam.iam_policy_iso_ext_app_role_arn}", //whilst spg-iso smx in place, remove when using haproxy + mpxhybrid
    "${data.terraform_remote_state.iam.iam_policy_mpx_int_app_role_arn}"]


  roles_allowed_to_decrypt_crc = [
    "${data.terraform_remote_state.iam.iam_policy_iso_ext_app_role_arn}",//for when using all in one
    "${data.terraform_remote_state.iam.iam_policy_mpx_int_app_role_arn}",//for when using all in one
    "${data.terraform_remote_state.iam.iam_policy_crc_int_app_role_arn}"]

  hmpps_asset_name_prefix = "${data.terraform_remote_state.common.hmpps_asset_name_prefix}"

}

#################################################################
# KMS KEY GENERATION - FOR ENCRYPTION OF CERTIFICATE PRIVATE KEYS
#################################################################


data "template_file" "kms_spg_tls_policy" {
  template = "${file("policies/kms-certificate-administration-policy.tpl.json")}"

  vars {
    accountID = "${data.aws_caller_identity.current.account_id}"
    roles_allowed_to_decrypt = "${jsonencode(local.roles_allowed_to_decrypt_spg_tls)}"
  }
}

data "template_file" "kms_spg_signing_policy" {
  template = "${file("policies/kms-certificate-administration-policy.tpl.json")}"

  vars {
    accountID = "${data.aws_caller_identity.current.account_id}"
    roles_allowed_to_decrypt = "${jsonencode(local.roles_allowed_to_decrypt_spg_signing)}"
  }
}


data "template_file" "kms_spg_crc_policy" {
  template = "${file("policies/kms-certificate-administration-policy.tpl.json")}"

  vars {
    accountID = "${data.aws_caller_identity.current.account_id}"
    roles_allowed_to_decrypt = "${jsonencode(local.roles_allowed_to_decrypt_crc)}"

  }
}


module "certificates_spg_tls_cert_kms_key" {
  source = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//kms_custom_policy"
  kms_key_name = "${local.hmpps_asset_name_prefix}-certificates-spg-tls-cert"
  policy = "${data.template_file.kms_spg_tls_policy.rendered}"
  tags = "${local.tags}"
}

module "certificates_spg_signing_cert_kms_key" {
  source = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//kms_custom_policy"
  kms_key_name = "${local.hmpps_asset_name_prefix}-certificates-spg-message-signing-certificate"
  policy = "${data.template_file.kms_spg_signing_policy.rendered}"
  tags = "${local.tags}"
}


module "certificates_spg_crc_cert_kms_key" {
  source = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//kms_custom_policy"
  kms_key_name = "${local.hmpps_asset_name_prefix}-certificates-spg-crc-cert"
  policy = "${data.template_file.kms_spg_crc_policy.rendered}"
  tags = "${local.tags}"
}
