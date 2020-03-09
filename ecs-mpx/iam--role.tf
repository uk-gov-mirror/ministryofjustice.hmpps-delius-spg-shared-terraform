# Task Execution Role for pulling the image
resource "aws_iam_role" "iam_execute_role" {
  name               = "${local.hmpps_asset_name_prefix}-exec-iam"
  assume_role_policy = "${data.template_file.ecstasks_assumerole_template.rendered}"
}

resource "aws_iam_role_policy" "ecs_task_definition_iam_access_policy" {
  name   = "${local.hmpps_asset_name_prefix}-access-iam"
  role   = "${aws_iam_role.iam_execute_role.name}"
  policy = "${data.template_file.ecs_tasks_assumerole_template.rendered}"
}

resource "aws_iam_role" "offenderapi_task_role" {
  name               = "${local.hmpps_asset_name_prefix}-access-iam"
  assume_role_policy = "${data.template_file.ecstasks_assumerole_template.rendered}"
}