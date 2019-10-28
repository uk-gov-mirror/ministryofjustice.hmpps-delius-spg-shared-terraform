terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

provider "aws" {
  region  = "${var.region}"
  version = ">= 2.1.0"
}

locals {
  env_prefix  = "${data.terraform_remote_state.common.short_environment_name}"
  table_name  = "${local.env_prefix}-spg-scr-sequence"
}

data "aws_caller_identity" "current" {}

#-------------------------------------------------------------
### Remote states
#-------------------------------------------------------------

## Common
data "terraform_remote_state" "common" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "spg/common/terraform.tfstate"
    region = "${var.region}"
  }
}

## IAM remote state for the internal spgw mpx role name
data "terraform_remote_state" "iam" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "spg/iam/terraform.tfstate"
    region = "${var.region}"
  }
}

#--------------------------------------------------------------
### Template files
#--------------------------------------------------------------
data "template_file" "initialise_sequence" {
  template = "${file("${path.module}/template/initialise_sequence.tpl")}"

  vars {
    hash_key                   = "${var.hash_key}"
    initial_sequence_value     = "${var.initial_sequence_value}"
  }
}

data "template_file" "table_access_policy" {
  template = "${file("${path.module}/template/table_access_policy.tpl")}"
  vars {
    region                     = "${var.region}"
    current_account_id         = "${data.aws_caller_identity.current.account_id}"
    environment                = "${local.env_prefix}"
    }
}

#--------------------------------------------------------------
### Dynamodb Resources
#--------------------------------------------------------------
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
  item       = "${data.template_file.initialise_sequence.rendered}"
}

#--------------------------------------------------------------
### Define and attach the table access policy to the spgw-mpx-int-role
#--------------------------------------------------------------
resource "aws_iam_policy" "sequence-table-access-policy" {
  name   = "${local.env_prefix}-sequence-table-update-access-policy"
  policy = "${data.template_file.table_access_policy.rendered}"
}

resource "aws_iam_role_policy_attachment" "spgw-mpx-int-ec2" {
  role       = "${data.terraform_remote_state.iam.iam_policy_mpx_int_app_role_name}"
  policy_arn = "${aws_iam_policy.sequence-table-access-policy.arn}"
}