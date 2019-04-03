# key
output "self_signed_cert_private_key" {
  value     = "${module.generate_private_key.private_key}"
  sensitive = true
}

# csr
output "self_signed_cert_csr_pem" {
  value     = "${module.generate_csr.cert_request_pem}"
  sensitive = true
}