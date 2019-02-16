## Launch the EC2 instance
resource "aws_instance" "my_web_server_dev" {
  ami                  = "${data.aws_ami.linux.id}" ## Get most recent AMI ID ##
  instance_type        = "t2.micro"
  iam_instance_profile = "${var.iam_role_profile}"

  user_data                   = "${data.template_file.my_web_server_dev_user_data.rendered}"
  subnet_id                   = "${var.subnet_id}"
  associate_public_ip_address = true
  availability_zone = "${var.availability_zone}"
  vpc_security_group_ids      = ["${aws_security_group.my_web_server_dev_SG.id}"]
  key_name                    = "${var.keypair_name}"
  tags                        = "${merge(var.default_tags, map("Name", "my_web_server"))}"
}

data "template_file" "my_web_server_dev_user_data" {
  template = <<EOF
#!/bin/bash
sudo yum update -y
aws s3 cp s3://${var.ops_bucket_name}/web_server_dev/index.html /home/ec2-user
aws s3 cp s3://${var.ops_bucket_name}/web_server_dev/bootstrap.sh /home/ec2-user
sudo chmod +x /home/ec2-user/bootstrap.sh
echo "deploying web server"
sudo /home/ec2-user/bootstrap.sh &> /home/ec2-user/setup.txt
EOF
  vars {}
}

##### Instance security group
resource "aws_security_group" "my_web_server_dev_SG" {
  name        = "my_web_server_sg"
  description = "Instance security group"
  vpc_id      = "${data.aws_vpc.main.id}"

  tags = "${merge(var.default_tags, map("Name", "my_web_server_sg"))}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group_rule" "my_web_server_dev_ssh_port" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = "${aws_security_group.my_web_server_dev_SG.id}"
  cidr_blocks       = ["172.20.17.209/32"]
}

resource "aws_security_group_rule" "my_web_server_dev_http_port" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = "${aws_security_group.my_web_server_dev_SG.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}
####### load balancer security group
resource "aws_security_group" "my_lb_SG" {
  name        = "my_lb_sg"
  description = "my load balancer security group"
  vpc_id      = "${data.aws_vpc.main.id}"

  tags = "${merge(var.default_tags, map("Name", "my_lb_sg"))}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "lb_https_port" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.my_lb_SG.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}

### The load balancer is used to forward instance http (80) port to load balancer port https (443)
resource "aws_elb" "my_web_server" {
  name = "${var.instance_name}"
  subnets  = ["${var.subnet_id}"]
  internal = "false"

  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "${var.ssl_cert_id}"
  }

  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 80
    lb_protocol        = "http"
  }

  health_check {
    healthy_threshold   = 10
    unhealthy_threshold = 2
    timeout             = 5
    target              = "HTTP:80/index.html"
    interval            = 30
  }

  security_groups = ["${aws_security_group.my_lb_SG.id}"]

  instances    = ["${aws_instance.my_web_server_dev.id}"]
  idle_timeout = 400

  tags = "${merge(var.default_tags, map("Name", "${var.instance_name}"))}"
}

## create a route 53 record set in domain for adding load balancer dns for accessing using dns name.
resource "aws_route53_record" "www" {
  zone_id = "${var.zone_id}"
  name    = "${var.instance_name}"
  type    = "A"

  alias {
    name                   = "${aws_elb.my_web_server.dns_name}"
    zone_id                = "${aws_elb.my_web_server.zone_id}"
    evaluate_target_health = true
  }
}

