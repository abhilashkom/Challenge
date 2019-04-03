profile = "sailab"

region = "us-east-1"

vpc_name = "****"

environment_name = "lab"

keypair_name = "my_aws_key"

ops_bucket_name = "sai-ops"

default_tags = {
  Name                 = "my-web-server"
  Application          = "web-server"
  Creator              = "Terraform"
}

subnet_id = "subnet-*****"


iam_role_profile = "ec2-profile"

availability_zone = "us-east-1b"


ssl_cert_id = "arn:aws:acm:us-east-1:************:certificate/**********************"

instance_name = "my-web-server"

zone_id = "**********"
