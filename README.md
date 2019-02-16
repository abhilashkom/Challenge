# Saikrishna_Challenge
 Web Server Challenge
This project will spin up a server in AWS and install apache and crete a load balancer and route 53 record set for accessing the application using DNS name. Cloudwatch file is used for monitoring alarms and creating dashboards of the server. These alerts when triggered are forwarded to the SNS topic which is subscribed to my email address.
The web server listens on port 80 http and the requests are redirected to port 443 https/ssl using a load balancer listener and ssl cert.
