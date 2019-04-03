############################################
# GENERATE KEY AND CSR
############################################
# KEY
module "generate_private_key" {
  source    = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=pre-shared-vpc//modules//tls//tls_private_key"
  algorithm = "${var.self_signed_server_algorithm}"
  rsa_bits  = "${var.self_signed_server_rsa_bits}"
}

# csr from key
module "generate_csr" {
  source          = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=pre-shared-vpc//modules//tls//tls_cert_request"
  key_algorithm   = "${var.self_signed_server_algorithm}"
  private_key_pem = "${module.generate_private_key.private_key}"

  subject = {
    common_name = "${var.dns_common_name}"
    organization = "${var.app_common_name}"
  }
  dns_names       = ["${var.dns_common_name}"]
}




module "parameter_store_put_private_key" {
  source         = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=pre-shared-vpc//modules//ssm//parameter_store_file"
  parameter_name = "${var.app_common_name}-self-signed-private-key"
  description    = "${var.app_common_name}-self-signed-private-key"
  type           = "SecureString"
  value          = "${module.generate_private_key.private_key}"
  tags           = "${var.tags}"
}


//not sure how we will recieve/store/track/apply the POs CSRs,
//but potentially using the param store may be an option (ie if we had a web gui for POs to self provision)

//module "create_parameter_csr" {
//  source         = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=pre-shared-vpc//modules//ssm//parameter_store_file"
//  parameter_name = "${local.common_name}-self-signed-private-key"
//  description    = "${local.common_name}-self-signed-private-key"
//  type           = "SecureString"
//  value          = "${module.server_key.private_key}"
//  tags           = "${local.tags}"
//}
