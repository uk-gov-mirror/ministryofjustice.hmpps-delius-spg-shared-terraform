output "amazon_mq_broker_connect_url" {
  value = "${data.null_data_source.broker_export_url.outputs["broker_connect_url"]}"
}

output "amazon_mq_broker_1_fqdn" {
  value = "${data.null_data_source.broker_a_export_fqdn.outputs["broker_fqdn"]}"
}