# key
output "self_signed_server_private_key" {
  value     = "${module.sign_cert.private_key}"
  sensitive = true
}

# csr
output "self_signed_server_cert_request_pem" {
  value     = "${module.sign_cert.cert_request_pem}"
  sensitive = true
}

# cert
output "self_signed_server_cert_pem" {
  value = "${module.sign_cert.cert_pem  }"
}
