data "archive_file" "notify-slack-lambda" {
  type        = "zip"
  source_file = "${path.module}/lambda/${local.lambda_name}.js"
  output_path = "${path.module}/files/${local.short_environment_name}-${local.lambda_name}.zip"
}

data "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"
}

resource "aws_lambda_function" "notify-slack" {
  filename         = "${data.archive_file.notify-slack-lambda.output_path}"
  function_name    = "${local.short_environment_name}-${local.lambda_name}"
  role             = "${data.aws_iam_role.lambda_exec_role.arn}"
  handler          = "${local.lambda_name}.handler"
  source_code_hash = "${base64sha256(file("${data.archive_file.notify-slack-lambda.output_path}"))}"
  runtime          = "${var.lambda_runtime}"
}

resource "aws_lambda_permission" "with_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.notify-slack.arn}"
  principal     = "sns.amazonaws.com"
  source_arn    = "${aws_sns_topic.alarm_notification.arn}"
}
