# key
output "self_signed_server_private_key" {
  value     = "${module.server_key.private_key}"
  sensitive = true
}

# csr
output "self_signed_server_cert_request_pem" {
  value     = "${module.server_csr.cert_request_pem}"
  sensitive = true
}