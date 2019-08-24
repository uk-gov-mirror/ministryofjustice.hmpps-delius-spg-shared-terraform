output "certificates_spg_tls_cert_kms_arn" {
  value = "${module.certificates_spg_tls_cert_kms_key.kms_arn}"
}

output "certificates_spg_tls_cert_kms_id" {
  value = "${module.certificates_spg_tls_cert_kms_key.kms_key_id}"
}

output "certificates_spg_signing_cert_kms_arn" {
  value = "${module.certificates_spg_signing_cert_kms_key.kms_arn}"
}

output "certificates_spg_signing_cert_kms_id" {
  value = "${module.certificates_spg_signing_cert_kms_key.kms_key_id}"
}


output "certificates_spg_crc_cert_kms_arn" {
  value = "${module.certificates_spg_crc_cert_kms_key.kms_arn}"
}

output "certificates_spg_crc_cert_kms_key_id" {
  value = "${module.certificates_spg_crc_cert_kms_key.kms_key_id}"
}







