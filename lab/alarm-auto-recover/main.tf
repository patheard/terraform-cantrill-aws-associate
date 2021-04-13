data "aws_region" "current" {}

resource "aws_cloudwatch_metric_alarm" "auto_recovery_alarm" {
  alarm_name          = "EC2AutoRecover-${var.aws_instance_id}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "StatusCheckFailed_System"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Minimum"

  dimensions = {
    InstanceId = var.aws_instance_id
  }

  alarm_actions = ["arn:aws:automate:${data.aws_region.current.name}:ec2:${var.alarm_action}"]

  threshold         = "1"
  alarm_description = "Auto recover the EC2 instance if Status Check fails."
}
