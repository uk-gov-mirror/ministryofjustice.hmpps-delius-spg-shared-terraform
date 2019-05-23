//####################################################
//# Self Signed Cert
//####################################################
//module "crc_signing" {
//  source                                   = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//projects//alfresco//self-signed//server"
//  alfresco_app_name                        = "signing.crc.${local.spg_app_name}"
//  ca_cert_pem                              = "${module.private_root_ca.self_signed_ca_cert_pem}"
//  ca_private_key_pem                       = "${module.private_root_ca.self_signed_ca_private_key}"
//  common_name                              = "signing.crc.${local.common_name}"
//  environment_identifier                   = "${local.environment_identifier}"
//  internal_domain                          = "signing.crc.${local.internal_domain}"
//  region                                   = "${local.region}"
//  self_signed_server_algorithm             = "${var.self_signed_server_algorithm}"
//  self_signed_server_validity_period_hours = "${var.self_signed_server_validity_period_hours}"
//  self_signed_server_rsa_bits              = "${var.self_signed_server_rsa_bits}"
//  self_signed_server_early_renewal_hours   = "${var.self_signed_server_early_renewal_hours}"
//  tags                                     = "${local.tags}"
//
//  depends_on = [
//    "${module.private_root_ca.self_signed_ca_cert_pem}",
//    "${module.private_root_ca.self_signed_ca_private_key}",
//  ]
//}
//
//
//
//####################################################
//# Self Signed Cert
//####################################################
//# key
//output "crc_signing_private_key" {
//  value     = "${module.crc_signing.self_signed_server_private_key}"
//  sensitive = true
//}
//
//# csr
//output "crc_signing_cert_request_pem" {
//  value     = "${module.crc_signing.self_signed_server_cert_request_pem}"
//  sensitive = true
//}
//
//# cert
//output "crc_signing_cert_pem" {
//  value = "${module.crc_signing.self_signed_server_cert_pem}"
//}
