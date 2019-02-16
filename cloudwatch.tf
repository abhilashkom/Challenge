## Create Dashboards and alarms for monitoring the server

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.instance_name}-${var.region}"

  dashboard_body = <<EOF
 {
   "widgets": [
       {
          "type":"metric",
          "x":0,
          "y":0,
          "width":12,
          "height":6,
          "properties":{
             "view": "timeSeries",
	           "stacked": false,
             "metrics":[
                [ "AWS/EC2","CPUUtilization","InstanceId", "${aws_instance.my_web_server_dev.id}", { "stat": "Maximum" } ]
             ],
             "period":300,
             "region":"${var.region}",
             "title":"CPU"
          }
       },
	   {
          "type":"metric",
          "x":0,
          "y":0,
          "width":12,
          "height":6,
          "properties":{
             "view": "timeSeries",
	           "stacked": false,
             "metrics":[
			    [ "AWS/EC2","StatusCheckFailed","InstanceId", "${aws_instance.my_web_server_dev.id}", { "stat": "Maximum" } ]
             ],
             "period":300,
             "region":"${var.region}",
             "title":"Status Checks"
          }
       },
	   {
          "type":"metric",
          "x":0,
          "y":0,
          "width":12,
          "height":6,
          "properties":{
             "view": "timeSeries",
	           "stacked": false,
             "metrics":[
				[ "AWS/EC2","DiskReadOps","InstanceId", "${aws_instance.my_web_server_dev.id}", { "stat": "Average" } ],
				[ "AWS/EC2","DiskWriteOps","InstanceId", "${aws_instance.my_web_server_dev.id}", { "stat": "Average" } ]
             ],
             "period":300,
             "region":"${var.region}",
             "title":"Disk"
          }
       },
       {
          "type":"metric",
          "x":0,
          "y":0,
          "width":12,
          "height":6,
          "properties":{
             "view": "timeSeries",
	           "stacked": false,
             "metrics":[
			 	[ "AWS/EC2","NetworkOut","InstanceId", "${aws_instance.my_web_server_dev.id}", { "stat": "Average" } ],
			 	[ "AWS/EC2","NetworkIn","InstanceId", "${aws_instance.my_web_server_dev.id}", { "stat": "Average" } ]
             ],
             "period":300,
             "region":"${var.region}",
             "title":"Network"
          }
       }
   ]
 }
 EOF
}


data "aws_sns_topic" "serveralerts" {
  name = "ServerAlerts"
}

resource "aws_cloudwatch_metric_alarm" "CPU" {
  alarm_name          = "Host CPU high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
  treat_missing_data  = "breaching"
  alarm_description   = "This metric host cpu utilization"

  alarm_actions = [
    "${data.aws_sns_topic.serveralerts.arn}",
  ]
  dimensions {
    InstanceId = "${aws_instance.my_web_server_dev.id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "Server-is-Down" {
  alarm_name          = "${var.instance_name} is down- panic_time"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ELB"
  period              = "60"
  statistic           = "Average"
  threshold           = "1"
  treat_missing_data  = "missing"
  alarm_description   = "This metric monitors the ${var.instance_name} ELB for unhealthy hosts"

  dimensions {
    LoadBalancerName = "${var.instance_name}"
  }

  alarm_actions = [
    "${data.aws_sns_topic.serveralerts.arn}",
  ]
}

resource "aws_cloudwatch_metric_alarm" "NetworkIn" {
  alarm_name          = "Host NetworkIn is zero"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"

  metric_name        = "NetworkIn"
  namespace          = "AWS/EC2"
  period             = "300"
  statistic          = "Average"
  threshold          = "1"
  treat_missing_data = "notBreaching"
  alarm_description  = "This metric monitors host NetworkIn"

  alarm_actions = [
    "${data.aws_sns_topic.serveralerts.arn}",
  ]
  dimensions {
    InstanceId = "${aws_instance.my_web_server_dev.id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "NetworkOut" {
  alarm_name          = "Host NetworkOut is zero"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"

  metric_name        = "NetworkOut"
  namespace          = "AWS/EC2"
  period             = "300"
  statistic          = "Average"
  threshold          = "1"
  treat_missing_data = "notBreaching"
  alarm_description  = "This metric monitors host NetworkOut"

  alarm_actions = [
    "${data.aws_sns_topic.serveralerts.arn}",
  ]
  dimensions {
    InstanceId = "${aws_instance.my_web_server_dev.id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "StatusChecks" {
  alarm_name          = "Host StatusCheckFailed is 0"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "1"
  treat_missing_data  = "notBreaching"
  alarm_description   = "This metric monitors Host StatusChecks"

  alarm_actions = [
    "${data.aws_sns_topic.serveralerts.arn}",
  ]
  dimensions {
    InstanceId = "${aws_instance.my_web_server_dev.id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "DiskReadOps" {
  alarm_name          = "Host DiskReadOps is 0"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"

  metric_name        = "DiskReadOps"
  namespace          = "AWS/EC2"
  period             = "120"
  statistic          = "Average"
  threshold          = "1"
  treat_missing_data = "notBreaching"
  alarm_description  = "This metric monitors host DiskReadOps"

  alarm_actions = [
    "${data.aws_sns_topic.serveralerts.arn}",
  ]
  dimensions {
    InstanceId = "${aws_instance.my_web_server_dev.id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "DiskWriteOps" {
  alarm_name          = "Host DiskWriteOps is 0"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"

  metric_name        = "DiskWriteOps"
  namespace          = "AWS/EC2"
  period             = "120"
  statistic          = "Average"
  threshold          = "1"
  treat_missing_data = "notBreaching"
  alarm_description  = "This metric monitors host DiskWriteOps"

  alarm_actions = [
    "${data.aws_sns_topic.serveralerts.arn}",
  ]
  dimensions {
    InstanceId = "${aws_instance.my_web_server_dev.id}"
  }
}
