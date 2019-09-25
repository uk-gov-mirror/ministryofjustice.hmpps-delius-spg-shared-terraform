output "amazon_mq_broker_connect_url" {
  value = "${data.null_data_source.broker_export_url.outputs["broker_connect_url"]}"
}

output "aws_ssm_credentials_path" {
  value = "${local.credentials_ssm_path}"
}

output "broker_username" {
  value = "${data.aws_ssm_parameter.remote_broker_username.value}"
}

output "broker_instances" {
  value = "${local.broker_instances}"
}
