profile = "sailab"

region = "us-east-1"

vpc_name = "Sai Lab"

environment_name = "lab"

keypair_name = "my_aws_key"

ops_bucket_name = "sai-ops"

default_tags = {
  Name                 = "my-web-server"
  Application          = "web-server"
  Creator              = "Terraform"
}

subnet_id = "subnet-447f1018"


iam_role_profile = "ec2-profile"

availability_zone = "us-east-1b"


ssl_cert_id = "arn:aws:acm:us-east-1:************:certificate/97f3790a-e94c-48a6-bfa8-c9c2d683193b"

instance_name = "my-web-server"

zone_id = "Z3GQ3LWMCJT51R"
