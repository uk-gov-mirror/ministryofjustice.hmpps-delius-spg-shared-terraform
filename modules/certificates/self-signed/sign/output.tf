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
  value = "${module.sign_cert.cert_pem}"
}

## AWS PARAMETER STORE
output "self_signed_server_ssm_cert_pem_name" {
  value = "${module.parameter_store_put_cert.name}"
}

output "self_signed_server_ssm_private_key_name" {
  value = "${module.parameter_store_put_  .name}"
}
