terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

provider "aws" {
  region  = "${var.region}"
  version = ">= 2.1.0"
}

locals {
  sg_map_ids = "${data.terraform_remote_state.common.sg_map_ids}"

  int_lb_security_groups = ["${local.sg_map_ids["internal_lb_sg_id"]}",
                            "${local.sg_map_ids["bastion_in_sg_id"]}"]

  int_amq_security_groups = "${data.terraform_remote_state.common.amazonmq_inst_sg_id}"

  private_subnet_ids = [
    "${data.terraform_remote_state.common.private_subnet_ids[0]}",
    "${data.terraform_remote_state.common.private_subnet_ids[1]}"
  ]

  # Setup a broker instance count based on the broker deployment mode
  broker_instances = "${(var.aws_broker_deployment_mode) == "SINGLE_INSTANCE" ? 1 : 2}"
  broker_subnet_ids  = ["${slice(local.private_subnet_ids, 0, local.broker_instances)}"]
}

resource "aws_mq_broker" "SPG" {
  broker_name = "SPG-AMQ-Broker"

  configuration {
    id       = "${aws_mq_configuration.SPG.id}"
    revision = "${aws_mq_configuration.SPG.latest_revision}"
  }

  engine_type        = "ActiveMQ"
  engine_version     = "5.15.0"
  deployment_mode    = "${var.aws_broker_deployment_mode}"
  host_instance_type = "${var.aws_broker_host_instance_type}"
  security_groups    = ["${local.int_amq_security_groups}"]
  subnet_ids         = ["${local.broker_subnet_ids}"]

  user {
    username = "spgsmx"
    password = "spgsmx1000000"
    console_access = "true"
  }
}

resource "aws_mq_configuration" "SPG" {
  description    = "Amazon MQ Configuration for NDST AWS"
  name           = "NDST-Amazon-MQ"
  engine_type    = "ActiveMQ"
  engine_version = "5.15.0"

  data = <<DATA
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<broker xmlns="http://activemq.apache.org/schema/core">
  <plugins>
    <forcePersistencyModeBrokerPlugin persistenceFlag="true"/>
    <statisticsBrokerPlugin/>
    <timeStampingBrokerPlugin ttlCeiling="86400000" zeroExpirationOverride="86400000"/>
  </plugins>
</broker>
DATA
}

# Always created
resource "aws_route53_record" "dns_spg_amq_a_int_entry" {

  # Use the ID of the Hosted Zone we retrieved earlier
  zone_id = "${data.terraform_remote_state.common.private_zone_id}"
  name = "amazonmq-broker-1"
  type = "CNAME"
  ttl = "1800"
  count = 1
  records = ["${data.null_data_source.broker_a_export_fqdn.outputs["broker_fqdn"]}"]
  depends_on = ["aws_mq_broker.SPG"]
}

# Optionally created
resource "aws_route53_record" "dns_spg_amq_b_int_entry" {

  # Use the ID of the Hosted Zone we retrieved earlier
  zone_id = "${data.terraform_remote_state.common.private_zone_id}"
  name = "amazonmq-broker-2"
  type = "CNAME"
  ttl = "1800"
  # The count will resolve to zero on a SINGLE_INSTANCE and this resource will therefore not get created
  count = "${(local.broker_instances) == 1 ? 0 : 1}"
  records = ["${aws_mq_broker.SPG.instances.1.ip_address}"]
  depends_on = ["aws_mq_broker.SPG"]
}

# The ssl port should always be 61617, but calculate it from the broker endpoints (SSL always at endpoint offset zero)
# Format is "ssl://[fqdn]:port"
data "null_data_source" "broker_export_port" {
  inputs = {
        broker_ssl_port = "${element(split(":", aws_mq_broker.SPG.instances.0.endpoints[0]),2)}"
  }
}

# The FQDN is only available as a substring of the exported endpoints in the format "[protocol]://fqdn:port"
# Split the full url on the colon (:) which returns a list
# Use element to take the second entry (//[fqdn])
# Use substr to remove the //
#
data "null_data_source" "broker_a_export_fqdn" {
  inputs = {
      broker_fqdn = "${substr(element(split(":", aws_mq_broker.SPG.instances.0.endpoints.0),1), 2, -1)}"
  }
}

resource "null_resource" "broker_b_export_fqdn" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    broker_fqdn = "${local.broker_instances == 1 ?
                        substr(element(split(":", aws_mq_broker.SPG.instances.0.endpoints.0),1), 2, -1) :
                        format("")}"
  }
}


# Construct the amazon MQ connection url from the dns names and depending on how many instances
# This data source is then used as an output to update the remote state
data "null_data_source" "broker_export_url" {

  inputs = {

    broker_connect_url =  "${local.broker_instances == 1 ?
                                format("ssl://%s:%s",
                                        aws_route53_record.dns_spg_amq_a_int_entry.fqdn,
                                        data.null_data_source.broker_export_port.outputs["broker_ssl_port"]):
                                format("failover(ssl://%s:%s, ssl://%s:%s)",
                                        aws_route53_record.dns_spg_amq_a_int_entry.fqdn,
                                        data.null_data_source.broker_export_port.outputs["broker_ssl_port"],
                                        aws_route53_record.dns_spg_amq_a_int_entry.fqdn,
                                        data.null_data_source.broker_export_port.outputs["broker_ssl_port"])}"
  }
}