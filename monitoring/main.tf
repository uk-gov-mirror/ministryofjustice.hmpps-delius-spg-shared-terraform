terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
  required_version = "~> 0.11"
}

provider "aws" {
  region  = "${var.region}"
  version = "~> 2.1.0"
}

# Shared data and constants

locals {
  tags              = "${merge(var.tags, map("Build", "${var.build_tag}"))}"
  short_environment_name = "${data.terraform_remote_state.common.short_environment_name}"
  app_hostnames          = "${data.terraform_remote_state.common.app_hostnames}"
  hmpps_asset_name_prefix = "${data.terraform_remote_state.common.hmpps_asset_name_prefix}"
  project_name_abbreviated = "${data.terraform_remote_state.common.project_name_abbreviated}"
  spg_app_name = "${data.terraform_remote_state.common.spg_app_name}"

}

### SNS

resource "aws_sns_topic" "alarm_notification" {
  name               = "${local.short_environment_name}-${local.spg_app_name}-alarm-notification"
}

resource "aws_sns_topic_subscription" "alarm_subscription" {
  topic_arn          = "${aws_sns_topic.alarm_notification.arn}"
  protocol           = "lambda"
  endpoint           = "${aws_lambda_function.notify-slack.arn}"
}

### Lambda

locals {
  lambda_name = "spgw_alarm_slack_notification"
}

data "archive_file" "notify-slack-lambda" {
  type               = "zip"
  source_file        = "${path.module}/lambda/${local.lambda_name}.js"
  output_path        = "${path.module}/files/${local.short_environment_name}-${local.lambda_name}.zip"
}

data "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"
}

resource "aws_lambda_function" "notify-slack" {
  filename           = "${data.archive_file.notify-slack-lambda.output_path}"
  function_name      = "${local.lambda_name}"
  role               = "${data.aws_iam_role.lambda_exec_role.arn}"
  handler            = "${local.lambda_name}.handler"
  source_code_hash   = "${base64sha256(file("${data.archive_file.notify-slack-lambda.output_path}"))}"
  runtime            = "nodejs8.10"
}

resource "aws_lambda_permission" "with_sns" {
  statement_id        = "AllowExecutionFromSNS"
  action              = "lambda:InvokeFunction"
  function_name       = "${aws_lambda_function.notify-slack.arn}"
  principal           = "sns.amazonaws.com"
  source_arn          = "${aws_sns_topic.alarm_notification.arn}"
}