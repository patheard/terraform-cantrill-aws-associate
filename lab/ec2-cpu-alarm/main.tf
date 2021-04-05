
data "aws_sns_topic" "sns_alarm_topic" {
  name = "billing-alarm-notification-cad-${var.env}"
}

module "ec2_stressed" {
  source = "../ec2"

  env            = var.env
  name           = var.name
  ingress_ip     = var.ingress_ip
  instance_type  = var.instance_type
  ssh_public_key = var.ssh_public_key

  user_data = <<-EOF
  #!/bin/bash
  sudo yum install epel stress -y
	EOF
}

resource "aws_cloudwatch_metric_alarm" "cpu_use" {
  alarm_name          = "cpu-alarm-${var.env}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = var.cpu_threshold
  alarm_description   = "This metric monitors ec2 cpu use"
  alarm_actions       = [data.aws_sns_topic.sns_alarm_topic.arn]

  dimensions = {
    InstanceId = module.ec2_stressed.id
  }
}
