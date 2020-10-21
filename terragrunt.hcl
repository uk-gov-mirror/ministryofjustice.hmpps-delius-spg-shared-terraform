remote_state {

  backend = "s3"

  config = {
    encrypt = true
    bucket = "${get_env("TG_REMOTE_STATE_BUCKET", "REMOTE_STATE_BUCKET")}"
    key = "spg/${path_relative_to_include()}/terraform.tfstate"
    region = "${get_env("TG_REGION", "AWS-REGION")}"

    dynamodb_table = "${get_env("TG_ENVIRONMENT_IDENTIFIER", "ENVIRONMENT_IDENTIFIER")}-lock-table"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

  terraform  {
    extra_arguments "common_vars" {
        commands = [
          "destroy",
          "plan",
          "import",
          "push",
          "refresh",
        ]

        arguments = [
          "-var-file=../env_configs/${get_env("TG_COMMON_DIRECTORY","common")}/common.tfvars",
          "-var-file=../env_configs/${get_env("TG_ENVIRONMENT_NAME", "ENVIRONMENT")}/${get_env("TG_ENVIRONMENT_NAME", "ENVIRONMENT")}.tfvars",
          "-var-file=../env_configs/${get_env("TG_ENVIRONMENT_NAME", "ENVIRONMENT")}/sub-projects/spg.tfvars",
          "-var-file=../env_configs/${get_env("TG_ENVIRONMENT_NAME", "ENVIRONMENT")}/sub-projects/parent-orgs.tfvars",
        ]
      }
    }


