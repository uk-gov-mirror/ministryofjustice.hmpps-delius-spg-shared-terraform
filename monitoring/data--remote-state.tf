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

data "terraform_remote_state" "ecs_crc" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "spg/ecs-crc/terraform.tfstate"
    region = "${var.region}"
  }
}

data "terraform_remote_state" "ecs_mpx" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "spg/ecs-mpx/terraform.tfstate"
    region = "${var.region}"
  }
}

data "terraform_remote_state" "ecs_iso" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "spg/ecs-iso/terraform.tfstate"
    region = "${var.region}"
  }
}
