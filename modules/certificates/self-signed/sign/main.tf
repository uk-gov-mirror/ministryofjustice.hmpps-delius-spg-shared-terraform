####################################################
# DATA SOURCE MODULES FROM OTHER TERRAFORM BACKENDS
####################################################

locals {
  tags        = "${var.tags}"
  app_common_name = "${var.app_common_name}"
  dns_common_name = "${var.internal_domain}"

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
    "client_auth",
  ]

  ca_cert_pem     = "${var.ca_cert_pem}"
  internal_domain = "${var.internal_domain}"
}


############################################
# SIGN CERT
############################################
# cert
module "sign_cert" {
  source                = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=pre-shared-vpc//modules//tls//tls_locally_signed_cert"
  cert_request_pem      = "${var.cert_request_pem}"
  ca_key_algorithm      = "${var.self_signed_server_algorithm}"
  ca_private_key_pem    = "${var.ca_private_key_pem}"
  ca_cert_pem           = "${local.ca_cert_pem}"
  validity_period_hours = "${var.self_signed_server_validity_period_hours}"
  early_renewal_hours   = "${var.self_signed_server_early_renewal_hours}"

  allowed_uses = ["${local.allowed_uses}"]
}


############################################
# ADD TO SSM
############################################
# CERT
module "create_parameter_cert" {
  source         = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=pre-shared-vpc//modules//ssm//parameter_store_file"
  parameter_name = "${local.app_common_name}-${local.dns_common_name}-crt"
  description    = "${local.app_common_name}-${local.dns_common_name}-crt"
  type           = "String"
  value          = "${module.sign_cert.cert_pem}"
  tags           = "${local.tags}"
}
