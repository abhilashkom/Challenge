#!/bin/bash
set -x
# Exit immediately if a command exits with a non-zero status.
set -e
echo "updating before installing packages"
sudo yum update -y

#Install Apache web server
sudo yum install -y httpd24 php56 php56-mysqlnd

sudo service httpd start

sudo chkconfig httpd on

sudo groupadd www

sudo usermod -a -G www ec2-user

sudo chown -R ec2-user:ec2-user /var/www/html

## move index.html to /var/www/html and change permissions
sudo mv /home/ec2-user/index.html /var/www/html

sudo chmod 755 /var/www/html/index.html