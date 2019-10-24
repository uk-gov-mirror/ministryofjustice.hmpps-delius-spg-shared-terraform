terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

provider "aws" {
  region  = "${var.region}"
  version = ">= 2.1.0"
}

#-------------------------------------------------------------
### Getting the common details
#-------------------------------------------------------------
data "terraform_remote_state" "common" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "spg/common/terraform.tfstate"
    region = "${var.region}"
  }
}

data "template_file" "initialise_sequence" {
  template = "${file("${path.module}/template/initialise_sequence.tpl")}"

  vars {
    hash_key                        = "${var.hash_key}"
    initial_sequence_value          = "${var.initial_sequence_value}"
  }
}

locals {
  env_prefix  = "${data.terraform_remote_state.common.short_environment_name}"
  table_name  = "${local.env_prefix}-spg-scr-sequence"
}

resource "aws_dynamodb_table" "sequence_generator_table" {
  name           = "${local.table_name}"
  read_capacity  = "${var.read_capacity}"
  write_capacity = "${var.write_capacity}"
  hash_key       = "${var.hash_key}"

  attribute {
    name = "${var.hash_key}"
    type = "S"
  }

  tags = "${merge(var.tags, map("Name", "${local.table_name}"))}"
}

resource "aws_dynamodb_table_item" "sequence_value" {
  table_name = "${aws_dynamodb_table.sequence_generator_table.name}"
  hash_key   = "${aws_dynamodb_table.sequence_generator_table.hash_key}"

  item = "${data.template_file.initialise_sequence.rendered}"
}