#used by crc LB to accept calls from jenkins via engineering NAT
data "terraform_remote_state" "natgateway" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "natgateway/terraform.tfstate"
    region = "${var.region}"
  }
}
