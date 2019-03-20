############################################
# ADD TO KEY AND CSR
############################################
# KEY
module "server_key" {
  source    = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=pre-shared-vpc//modules//tls//tls_private_key"
  algorithm = "${var.self_signed_server_algorithm}"
  rsa_bits  = "${var.self_signed_server_rsa_bits}"
}

# csr from key
module "server_csr" {
  source          = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=pre-shared-vpc//modules//tls//tls_cert_request"
  key_algorithm   = "${var.self_signed_server_algorithm}"
  private_key_pem = "${module.server_key.private_key}"

  subject = {
    common_name = "${var.dns_common_name}"
    organization = "${var.app_common_name}"
  }
  dns_names       = ["${var.dns_common_name}"]
}




module "create_parameter_key" {
  source         = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=pre-shared-vpc//modules//ssm//parameter_store_file"
  parameter_name = "${var.app_common_name}-self-signed-private-key"
  description    = "${var.app_common_name}-self-signed-private-key"
  type           = "SecureString"
  value          = "${module.server_key.private_key}"
  tags           = "${var.tags}"
}


//not sure how we will recieve/store/apply the POs CSRs
//module "create_parameter_csr" {
//  source         = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=pre-shared-vpc//modules//ssm//parameter_store_file"
//  parameter_name = "${local.common_name}-self-signed-private-key"
//  description    = "${local.common_name}-self-signed-private-key"
//  type           = "SecureString"
//  value          = "${module.server_key.private_key}"
//  tags           = "${local.tags}"
//}
