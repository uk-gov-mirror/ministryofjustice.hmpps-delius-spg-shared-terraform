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
  default     = "mq.m5.large" #micro limited to 100 connections
  description = "The host_instance type of the Amazon MQ broker(s) options (mq.m5.large, mq.m5.xlarge, mq.m5.2xlarge, mq.m5.4xlarge)"
}

variable "aws_broker_deployment_mode" {
  type        = "string"
  default     = "ACTIVE_STANDBY_MULTI_AZ" // made default multi az until domain a/b bug fixed (amq alternates between zone a & b i think)
  description = "Either SINGLE_INSTANCE or ACTIVE_STANDBY_MULTI_AZ for a master/slave standby cluster"
}

variable "tags" {
  type = "map"
}
