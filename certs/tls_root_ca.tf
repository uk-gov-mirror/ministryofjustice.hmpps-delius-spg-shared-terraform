//####################################################
//# Self Signed Root CA
//####################################################
//module "private_root_ca" {
//  source                               = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//projects//alfresco//self-signed//ca"
//  is_ca_certificate                    = true
//  internal_domain                      = "${local.internal_domain}"
//  region                               = "${local.region}"
//  tags                                 = "${local.tags}"
//  common_name                          = "${local.common_name}"
//  self_signed_ca_rsa_bits              = "${var.self_signed_ca_rsa_bits}"
//  self_signed_ca_algorithm             = "${var.self_signed_ca_algorithm}"
//  self_signed_ca_validity_period_hours = "${var.self_signed_ca_validity_period_hours}"
//  self_signed_ca_early_renewal_hours   = "${var.self_signed_ca_early_renewal_hours}"
//  alfresco_app_name                    = "${local.spg_app_name}"
//  environment_identifier               = "${local.environment_identifier}"
//}
//
//# CA CERT from terrar/tls modules
//git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modues//tls//tls_self_signed_cert"
//resource "tls_self_signed_cert" "ca" {
//  key_algorithm         = "${local.key_algorithm}"
//  private_key_pem       = "${var.private_key_pem}"
//  subject               = ["${var.subject}"]
//  validity_period_hours = "${var.validity_period_hours}"
//  early_renewal_hours   = "${var.early_renewal_hours}"
//  is_ca_certificate     = "${var.is_ca_certificate}"
//  allowed_uses          = ["${var.allowed_uses}"]
//}
