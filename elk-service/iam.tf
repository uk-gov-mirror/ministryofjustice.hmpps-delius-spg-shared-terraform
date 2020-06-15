//resource "aws_iam_service_linked_role" "elk-audit" {
  //aws_service_name = "es.amazonaws.com"
//}

# IAM Role for Cognito auth'd users to assume when logged into Kibana
# ES Permissions for the role are assigned in the ES access policy document
resource "aws_iam_role" "elk-audit_kibana_role" {
  name               = "${local.name_prefix}-kibanauser-main-iam"
  assume_role_policy = "${data.template_file.elk-audit_kibana_assume_policy_template.rendered}"
}

resource "aws_iam_role_policy_attachment" "elk-audit_kibana_cognito_access" {
  role       = "${aws_iam_role.elk-audit_kibana_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonESCognitoAccess"
}

resource "aws_iam_role_policy_attachment" "elk-audit_kibana_es_access" {
  role       = "${aws_iam_role.elk-audit_kibana_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonESFullAccess"
}
