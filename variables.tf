variable "profile" {
  description = "AWS Profile name to use for credentials"
}

variable "region" {
  description = "AWS Region to do deployment"
}

variable "vpc_name" {
  description = "The name of the VPC to use"
}

variable "environment_name" {
  description = "The name of the environment"
}

variable "default_tags" {
  description = "Tags which should be applied to all resources"
  type        = "map"
}

variable "keypair_name" {
  description = "Name of the KeyPair to use with EC2 instances"
}

variable "iam_role_profile" {
  description = "Name of the KeyPair to use with EC2 instances"
}

variable "ops_bucket_name" {
  description = "Name of the S3 bucket containing all the shared bootstrap files"
}

variable "subnet_id" {
  description = "The subnet associated with jenkins server"
}

variable "instance_name" {
  description = "name of instance"
}


variable "availability_zone" {
  description = "availability zone"
}

variable "ssl_cert_id" {
  description = "id of ssl certificate"
}


variable "zone_id" {
  description = "specifing the zone id in tfvars file"
}
