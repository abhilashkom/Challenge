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

 data "aws_ami" "linux" {
   most_recent = true

   filter {
     name   = "name"
     values = ["amzn-ami-hvm-*"]
   }

   filter {
     name   = "architecture"
     values = ["x86_64"]
   }

   filter {
     name   = "virtualization-type"
     values = ["hvm"]
   }

   filter {
     name   = "root-device-type"
     values = ["ebs"]
   }
 }