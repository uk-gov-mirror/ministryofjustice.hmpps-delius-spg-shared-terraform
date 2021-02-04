terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region  = var.region
  version = "~> 3.2.0"
}


provider "template" {
  version = "~>2.1.2"
}
