data "aws_iam_policy_document" "amq_log_iam_publishing_policy_document" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["arn:aws:logs:*:*:log-group:/aws/amazonmq/*"]

    principals {
      identifiers = ["mq.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_cloudwatch_log_resource_policy" "amq_log_iam_publishing_policy" {
  policy_document = data.aws_iam_policy_document.amq_log_iam_publishing_policy_document.json
  policy_name     = "${local.env_prefix}-amq-cloudwatch-access-policy"
}

