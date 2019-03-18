resource "aws_lb" "environment" {
  name = "${var.lb_name}-nlb"
  internal = "false"
  load_balancer_type = "network"

  // security groups not possible with nlb
  //  security_groups    = ["${var.security_groups}"]
//  subnets = [
//    "${var.subnet_ids}"]

  enable_deletion_protection = "${var.enable_deletion_protection}"

  access_logs {
    bucket = "${var.s3_bucket_name}"
    prefix = "${var.lb_name}-lb"
    enabled = "${var.logs_enabled}"
  }

  tags = "${merge(var.tags, map("Name", "${var.lb_name}-lb"))}"

  lifecycle {
    create_before_destroy = true
  }


  //example for elastic ips https://www.terraform.io/docs/providers/aws/r/lb.html
  //  subnet_mapping {
  //    subnet_id     = "${aws_subnet.example1.id}"
  //    allocation_id = "${aws_eip.example1.id}"
  //  }
  //
  //  subnet_mapping {
  //    subnet_id     = "${aws_subnet.example2.id}"
  //    allocation_id = "${aws_eip.example2.id}"
  //  }



  subnet_mapping {
    subnet_id = "${var.public_subnet_ids[0]}"
    allocation_id = "${var.az_lb_eip_allocation_ids[0]}"
  }

  subnet_mapping {
    subnet_id = "${var.public_subnet_ids[1]}"
    allocation_id = "${var.az_lb_eip_allocation_ids[1]}"
  }

  subnet_mapping {
    subnet_id = "${var.public_subnet_ids[2]}"
    allocation_id = "${var.az_lb_eip_allocation_ids[2]}"
  }

}
//az1_lb_eip_allocation_id       = "${var.az1_lb_eip_allocation_id}"
//az2_lb_eip_allocation_id       = "${var.az2_lb_eip_allocation_id}"
//az3_lb_eip_allocation_id       = "${var.az3_lb_eip_allocation_id}"
//public_subnet_ids