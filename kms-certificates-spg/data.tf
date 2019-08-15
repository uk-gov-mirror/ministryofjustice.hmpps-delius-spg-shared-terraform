####################################################
# DATA CONSTANTS
####################################################
#-------------------------------------------------------------
### Getting current
#-------------------------------------------------------------
data "aws_region" "current" {}

#-------------------------------------------------------------
### Getting the current running account id
#-------------------------------------------------------------
data "aws_caller_identity" "current" {}




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


//#-------------------------------------------------------------
//### Getting the s3bucket
//#-------------------------------------------------------------
//data "terraform_remote_state" "s3buckets" {
//  backend = "s3"
//
//  config {
//    bucket = "${var.remote_state_bucket_name}"
//    key    = "spg/s3buckets/terraform.tfstate"
//    region = "${var.region}"
//  }
//}
//
//#-------------------------------------------------------------
//### Getting the ecr
//#-------------------------------------------------------------
//data "terraform_remote_state" "ecr" {
//  backend = "s3"
//
//  config {
//    bucket = "${var.remote_state_bucket_name}"
//    key    = "spg/ecr/terraform.tfstate"
//    region = "${var.region}"
//  }
//}
