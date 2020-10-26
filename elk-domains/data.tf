# Load in VPC state data for subnet placement
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "vpc/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "common" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "spg/common/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "elk-service" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "spg/elk-service/terraform.tfstate"
    region = var.region
  }
}

