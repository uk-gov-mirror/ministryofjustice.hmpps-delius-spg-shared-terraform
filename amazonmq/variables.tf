variable "region" {
  type        = "string"
  default     = "eu-west-2"
  description = "The default deployment region (London)"
}

variable "remote_state_bucket_name" {
  description = "Terraform remote state bucket name"
}

variable "aws_broker_host_instance_type" {
  type        = "string"
  default     = "mq.t2.micro"
  description = "The host_instance type of the Amazon MQ broker(s) options (mq.m5.large, mq.m5.xlarge, mq.m5.2xlarge, mq.m5.4xlarge)"
}

variable "aws_broker_deployment_mode" {
  type        = "string"
  default     = "ACTIVE_STANDBY_MULTI_AZ"
  description = "Either SINGLE_INSTANCE or ACTIVE_STANDBY_MULTI_AZ for a master/slave standby cluster"
}