####################################################
# DATA SOURCE MODULES FROM OTHER TERRAFORM BACKENDS
####################################################
#-------------------------------------------------------------
### Getting the common details
#-------------------------------------------------------------
data "terraform_remote_state" "common" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "spg/common/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "kms" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "spg/kms-certificates-spg/terraform.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "iam" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "spg/iam/terraform.tfstate"
    region = var.region
  }
}

