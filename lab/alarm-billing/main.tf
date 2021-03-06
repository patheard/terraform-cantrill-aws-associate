resource "aws_cloudwatch_metric_alarm" "billing" {
  alarm_name                = "billing-alarm-${lower(var.currency)}-${var.env}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "EstimatedCharges"
  namespace                 = "AWS/Billing"
  period                    = "28800"
  statistic                 = "Maximum"
  threshold                 = var.monthly_billing_threshold
  alarm_actions             = [aws_sns_topic.sns_alarm_topic.arn]

  dimensions = {
      Currency = var.currency
  }
}

resource "aws_sns_topic" "sns_alarm_topic" {
    name              = "billing-alarm-notification-${lower(var.currency)}-${var.env}"
    kms_master_key_id = aws_kms_key.alarm_encryption_key.id
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.sns_alarm_topic.arn
  protocol  = "email"
  endpoint  = var.email
}
