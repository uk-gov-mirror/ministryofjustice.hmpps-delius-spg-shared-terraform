####################################################
# Self Signed Cert
####################################################
module "spg_signing" {
  source                                   = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//projects//alfresco//self-signed//server"
  alfresco_app_name                        = "signing.spgw-ext.${local.spg_app_name}"
  ca_cert_pem                              = "${module.private_root_ca.self_signed_cert_csr_pem}"
  ca_private_key_pem                       = "${module.private_root_ca.self_signed_cert_private_key}"
  common_name                              = "signing.spgw-ext.${local.common_name}"
  environment_identifier                   = "${local.environment_identifier}"
  internal_domain                          = "signing.spgw-ext.${local.internal_domain}"
  region                                   = "${local.region}"
  self_signed_server_algorithm             = "${var.self_signed_server_algorithm}"
  self_signed_server_validity_period_hours = "${var.self_signed_server_validity_period_hours}"
  self_signed_server_rsa_bits              = "${var.self_signed_server_rsa_bits}"
  self_signed_server_early_renewal_hours   = "${var.self_signed_server_early_renewal_hours}"
  tags                                     = "${local.tags}"

  depends_on = [
    "${module.private_root_ca.self_signed_cert_csr_pem}",
    "${module.private_root_ca.self_signed_cert_private_key}",
  ]
}



####################################################
# Self Signed Cert
####################################################
# key
output "spg_signing_private_key" {
  value     = "${module.spg_signing.self_signed_server_private_key}"
  sensitive = true
}

# csr
output "spg_signing_cert_request_pem" {
  value     = "${module.spg_signing.self_signed_server_cert_request_pem}"
  sensitive = true
}

# cert
output "spg_signing_cert_pem" {
  value = "${module.spg_signing.self_signed_server_cert_pem}"
}
