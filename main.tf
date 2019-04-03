provider "aws" {
  region  = "${var.region}"
  profile = "${var.profile}"
}


data "aws_caller_identity" "current" {}

data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name}"]
  }
}
## query most recent ami id
