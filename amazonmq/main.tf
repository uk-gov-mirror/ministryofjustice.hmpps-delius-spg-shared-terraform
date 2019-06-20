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

  int_amq_security_groups = ["sg-03dec5ca185c632f9"]

  private_subnet_ids = [
    "${data.terraform_remote_state.common.private_subnet_ids[0]}"]

}

resource "aws_mq_broker" "SPG" {
  broker_name = "SPG-AMQ-Broker"

  configuration {
    id       = "${aws_mq_configuration.SPG.id}"
    revision = "${aws_mq_configuration.SPG.latest_revision}"
  }

  engine_type        = "ActiveMQ"
  engine_version     = "5.15.0"
  host_instance_type = "mq.t2.micro"
  security_groups    = ["${local.int_amq_security_groups}"]
  subnet_ids         = ["${local.private_subnet_ids}"]

  user {
    username = "spgsmx"
    password = "spgsmx1000000"
    console_access = "true"
  }
}

resource "aws_mq_configuration" "SPG" {
  description    = "SPG AMQ Configuration"
  name           = "SPG-Basic"
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

