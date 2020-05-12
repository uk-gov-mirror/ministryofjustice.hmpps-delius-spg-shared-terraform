resource "aws_cognito_user_pool" "elk-audit_user_pool" {
  name = "${local.name_prefix}-elk-audit-main-cog"

  # Create optional email attribute for potenetial future use
  schema = {
    attribute_data_type = "String"
    name                = "email"
    required            = "${var.elk-audit_cognito_conf["email_required"]}"
    mutable             = true

    string_attribute_constraints = {
      min_length = 5
      max_length = 512
    }
  }

  password_policy = {
    minimum_length    = "${var.elk-audit_cognito_conf["password_min_length"]}"
    require_uppercase = "${var.elk-audit_cognito_conf["password_uppercase"]}"
    require_lowercase = "${var.elk-audit_cognito_conf["password_lowercase"]}"
    require_numbers   = "${var.elk-audit_cognito_conf["password_lowercase"]}"
    require_lowercase = "${var.elk-audit_cognito_conf["password_numbers"]}"
    require_symbols   = "${var.elk-audit_cognito_conf["password_symbols"]}"
  }

  admin_create_user_config = {
    allow_admin_create_user_only = "${var.elk-audit_cognito_conf["admin_only_create"]}"

    # If user email attribute is set - contents for invite and password reset emails
    invite_message_template = {
      email_subject = "${var.environment_name} - NDST ELK Audit Stack"
      email_message = "Your Kibana username is {username} and temporary password is {####}"
      sms_message   = "Your username is {username} and temporary password is {####}"
    }
  }

  # Optionally add Lambda hooks to perform additional authz checks, e.g. check group membership
  #   lambda_config = {}

  username_attributes      = []
  auto_verified_attributes = ["${var.elk-audit_cognito_conf["auto_verified_attributes"]}"]
  # Account verification message
  verification_message_template = {
    email_subject = "${var.environment_name} - NDST ELK Audit Stack"
    email_message = "Your Kibana username is {username} and temporary password is {####}"
  }
  tags = "${
    merge(
        var.tags, 
        map("Name", "${local.name_prefix}-elk-audituser-main-cog"),
        map("Domain", "${var.elk-audit_cognito_conf["domain"]}")
        )
    }"
}

resource "aws_cognito_user_pool_domain" "elk-audit_user_pool_domain" {
  domain       = "${local.name_prefix}-${var.environment_type}-${var.elk-audit_cognito_conf["domain"]}"
  user_pool_id = "${aws_cognito_user_pool.elk-audit_user_pool.id}"
  count        = 1
}

resource "aws_cognito_identity_pool" "elk-audit_identity_pool" {
  # ID Pool name can only conatin alphanum and spaces
  identity_pool_name               = "NDST ELK Audit Stack ID Pool"
  allow_unauthenticated_identities = false

  # ES Service will create a Cognito provider and Client secret when auth is enabled

  # AWS ES Adds an additional ID Provider when auth is enabled. Ignore or TF will destroy it
  lifecycle {
    ignore_changes = [
      "cognito_identity_providers",
    ]
  }
}

# Attach the Kibana user IAM role to this id pool
resource "aws_cognito_identity_pool_roles_attachment" "elk-audit_kibana_role_attachement" {
  identity_pool_id = "${aws_cognito_identity_pool.elk-audit_identity_pool.id}"

  roles {
    "authenticated" = "${aws_iam_role.elk-audit_kibana_role.arn}"
  }
}
