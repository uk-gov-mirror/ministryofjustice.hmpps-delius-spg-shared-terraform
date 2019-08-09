####################################################
# DATA SOURCE MODULES FROM OTHER TERRAFORM BACKENDS
####################################################
### Getting the vpc details
#-------------------------------------------------------------
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "vpc/terraform.tfstate"
    region = "${var.region}"
  }
}

#-------------------------------------------------------------
### Getting the monitoring instance details
#-------------------------------------------------------------
data "terraform_remote_state" "monitor" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "shared-monitoring/terraform.tfstate"
    region = "${var.region}"
  }
}

#-------------------------------------------------------------
### Getting the sg details
#-------------------------------------------------------------
data "terraform_remote_state" "security-groups" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "security-groups/terraform.tfstate"
    region = "${var.region}"
  }
}

#-------------------------------------------------------------
### Getting the engineering platform vpc
#-------------------------------------------------------------
data "terraform_remote_state" "eng_remote_certificates_s3bucket" {
  backend = "s3"

  config {
    bucket   = "${var.eng_remote_state_bucket_name}"
    key      = "s3bucket-public-and-private-certificates/terraform.tfstate"
    region   = "${var.region}"
    role_arn = "${var.eng_role_arn}"
  }
}


