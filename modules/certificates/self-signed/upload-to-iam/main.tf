############################################
# ADD TO IAM
############################################
# upload to IAM
module "iam_server_certificate" {
  source            = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=pre-shared-vpc//modules//iam_certificate"
  name_prefix       = "${local.internal_domain}-cert"
  certificate_body  = "${module.server_cert.cert_pem}"
  private_key       = "${module.server_key.private_key}"
  certificate_chain = "${local.ca_cert_pem}"
  path              = "/${var.environment_identifier}/"
}
