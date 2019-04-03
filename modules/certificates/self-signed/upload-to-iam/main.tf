############################################
# ADD TO IAM
############################################
# upload to IAM
module "iam_server_certificate" {
  source            = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=pre-shared-vpc//modules//iam_certificate"
  name_prefix       = "${local.internal_domain}-cert"
  certificate_body  = "${var.cert_request_pem}"
  private_key       = "${var.server_key.private_key}"
  certificate_chain = "${var.ca_cert_pem}"
  path              = "/${var.environment_identifier}/"
}
