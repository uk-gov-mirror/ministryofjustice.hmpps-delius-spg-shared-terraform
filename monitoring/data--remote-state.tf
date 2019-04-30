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

//data "terraform_remote_state" "application" {
//  backend = "s3"
//
//  config {
//    bucket = "${var.remote_state_bucket_name}"
//    key    = "application/terraform.tfstate"
//    region = "${var.region}"
//  }
//}