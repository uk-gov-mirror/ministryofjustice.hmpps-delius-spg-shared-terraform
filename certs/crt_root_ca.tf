####################################################
# Self Signed Root CA
####################################################
module "private_root_key" {
  //  source                               = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//projects//alfresco//self-signed//ca"
  source                               = "../modules/certificates/self-signed/private-key-and-csr"
  is_ca_certificate                    = true
  internal_domain                      = "${local.internal_domain}"
  region                               = "${local.region}"
  tags                                 = "${local.tags}"
  common_name                          = "${local.common_name}"
  self_signed_ca_rsa_bits              = "${var.self_signed_ca_rsa_bits}"
  self_signed_ca_algorithm             = "${var.self_signed_ca_algorithm}"
  self_signed_ca_validity_period_hours = "${var.self_signed_ca_validity_period_hours}"
  self_signed_ca_early_renewal_hours   = "${var.self_signed_ca_early_renewal_hours}"
  alfresco_app_name                    = "${local.spg_app_name}"
  environment_identifier               = "${local.environment_identifier}"
}



module "private_root_cert" {
//  source                               = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//projects//alfresco//self-signed//ca"
  source                               = "../modules/certificates/self-signed/sign"
  is_ca_certificate                    = true
  internal_domain                      = "${local.internal_domain}"
  region                               = "${local.region}"
  tags                                 = "${local.tags}"
  common_name                          = "${local.common_name}"
  self_signed_ca_rsa_bits              = "${var.self_signed_ca_rsa_bits}"
  self_signed_ca_algorithm             = "${var.self_signed_ca_algorithm}"
  self_signed_ca_validity_period_hours = "${var.self_signed_ca_validity_period_hours}"
  self_signed_ca_early_renewal_hours   = "${var.self_signed_ca_early_renewal_hours}"
  alfresco_app_name                    = "${local.spg_app_name}"
  environment_identifier               = "${local.environment_identifier}"
}

# key
output "self_signed_ca_private_key" {
  value     = "${module.private_root_ca.self_signed_cert_private_key}"
  sensitive = true
}

# ca cert
output "self_signed_ca_cert_pem" {
  value = "${module.private_root_ca.self_signed_cert_csr_pem}"
}

//## AWS PARAMETER STORE
//output "self_signed_ca_ssm_cert_pem_name" {
//  value = "${module.private_root_ca.self_signed_ca_ssm_cert_pem_name}"
//}
