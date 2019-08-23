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

  roles_allowed_to_decrypt_iso = [
    "${data.terraform_remote_state.iam.iam_policy_iso_ext_app_role_arn}",
    "${data.terraform_remote_state.iam.iam_policy_mpx_int_app_role_arn}"]

  roles_allowed_to_decrypt_crc = [
    "${data.terraform_remote_state.iam.iam_policy_iso_ext_app_role_arn}",//for when using all in one
    "${data.terraform_remote_state.iam.iam_policy_mpx_int_app_role_arn}",//for when using all in one
    "${data.terraform_remote_state.iam.iam_policy_crc_int_app_role_arn}"]

}

#################################################################
# KMS KEY GENERATION - FOR ENCRYPTION OF CERTIFICATE PRIVATE KEYS
#################################################################


data "template_file" "kms_spg_iso_policy" {
  template = "${file("policies/kms-certificate-administration-policy.tpl.json")}"

  vars {
    accountID = "${data.aws_caller_identity.current.account_id}"
    roles_allowed_to_decrypt = "${jsonencode(local.roles_allowed_to_decrypt_iso)}"
  }
}

data "template_file" "kms_spg_crc_policy" {
  template = "${file("policies/kms-certificate-administration-policy.tpl.json")}"

  vars {
    accountID = "${data.aws_caller_identity.current.account_id}"
    roles_allowed_to_decrypt = "${jsonencode(local.roles_allowed_to_decrypt_crc)}"

  }
}


module "certificates_spg_iso_cert_kms_key" {
  source = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//kms_custom_policy"
  kms_key_name = "${var.short_environment_identifier}-certificates-spg-iso-cert"
  policy = "${data.template_file.kms_spg_iso_policy.rendered}"
  tags = "${local.tags}"
}

module "certificates_spg_crc_cert_kms_key" {
  source = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//kms_custom_policy"
  kms_key_name = "${var.short_environment_identifier}-certificates-spg-crc-cert"
  policy = "${data.template_file.kms_spg_crc_policy.rendered}"
  tags = "${local.tags}"
}
