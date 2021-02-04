variable "region" {
  type        = string
  default     = "eu-west-2"
  description = "The default deployment region (London)"
}

locals {
  pattern = "messageNotificationStatusCode=601"
}

output "pattern" {
  value = urlencode(local.pattern)
}

