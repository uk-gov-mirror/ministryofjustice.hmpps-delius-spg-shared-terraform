####################################################
# DATA SOURCE MODULES FROM OTHER TERRAFORM BACKENDS
####################################################
#-------------------------------------------------------------
### Getting the common details
#-------------------------------------------------------------
data "terraform_remote_state" "common" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "spg/common/terraform.tfstate"
    region = "${var.region}"
  }
}

#-------------------------------------------------------------
### Getting the IAM details
#-------------------------------------------------------------
data "terraform_remote_state" "iam" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "spg/iam/terraform.tfstate"
    region = "${var.region}"
  }
}

#-------------------------------------------------------------
### Getting the security groups details
#-------------------------------------------------------------
//in common
//data "terraform_remote_state" "security-groups" {
//  backend = "s3"
//
//  config {
//    bucket = "${var.remote_state_bucket_name}"
//    key    = "spg/security-groups/terraform.tfstate"
//    region = "${var.region}"
//  }
//}

#-------------------------------------------------------------
### Getting the s3bucket
#-------------------------------------------------------------
data "terraform_remote_state" "s3buckets" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "spg/s3buckets/terraform.tfstate"
    region = "${var.region}"
  }
}

#-------------------------------------------------------------
### Getting the ecr
#-------------------------------------------------------------
data "terraform_remote_state" "ecr" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "spg/ecr/terraform.tfstate"
    region = "${var.region}"
  }
}


#-------------------------------------------------------------
### Getting the persistent eip
#-------------------------------------------------------------
data "terraform_remote_state" "persistent_spg" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "persistent/spg/terraform.tfstate"
    region = "${var.region}"
  }
}

////in common
//#-------------------------------------------------------------
//### Getting the vpc details
//#-------------------------------------------------------------
//data "terraform_remote_state" "vpc" {
//  backend = "s3"
//
//  config {
//    bucket = "${var.remote_state_bucket_name}"
//    key    = "vpc/terraform.tfstate"
//    region = "${var.region}"
//  }
//}

