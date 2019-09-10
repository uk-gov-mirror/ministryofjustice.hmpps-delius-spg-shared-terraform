output "amazon_mq_broker_connect_url" {
  value = "${data.null_data_source.broker_exports.outputs["broker_connect_url"]}"
}
