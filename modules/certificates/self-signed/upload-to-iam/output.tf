
# iam server cert
output "self_signed_server_iam_server_certificate_name" {
  value = "${module.iam_server_certificate.name}"
}

output "self_signed_server_iam_server_certificate_id" {
  value = "${module.iam_server_certificate.id}"
}

output "self_signed_server_iam_server_certificate_arn" {
  value = "${module.iam_server_certificate.arn}"
}

output "self_signed_server_iam_server_certificate_path" {
  value = "${module.iam_server_certificate.path}"
}
