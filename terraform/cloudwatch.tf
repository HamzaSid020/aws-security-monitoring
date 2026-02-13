# CloudWatch Alarms for security events
resource "aws_cloudwatch_metric_alarm" "guardduty_finding" {
  alarm_name          = "guardduty-critical-finding"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name        = "Findings"
  namespace          = "AWS/GuardDuty"
  period             = "300"
  statistic          = "Sum"
  threshold          = "0"
  alarm_description  = "This alarm monitors for GuardDuty findings"
  alarm_actions      = [aws_sns_topic.security_alerts.arn]

  dimensions = {
    DetectorId = aws_guardduty_detector.main.id
  }
}

resource "aws_cloudwatch_metric_alarm" "unauthorized_api_calls" {
  alarm_name          = "unauthorized-api-calls"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name        = "UnauthorizedAttempts"
  namespace          = "AWS/CloudTrail"
  period             = "300"
  statistic          = "Sum"
  threshold          = "0"
  alarm_description  = "Monitor for unauthorized API calls"
  alarm_actions      = [aws_sns_topic.security_alerts.arn]
}

# Custom CloudWatch Logs metric filter for suspicious activities
resource "aws_cloudwatch_log_metric_filter" "root_account_usage" {
  name           = "root-account-usage"
  pattern        = "{ $.userIdentity.type = \"Root\" && $.eventType = \"AwsApiCall\" }"
  log_group_name = aws_cloudwatch_log_group.cloudtrail_logs.name

  metric_transformation {
    name          = "RootAccountUsageCount"
    namespace     = "SecurityMetrics"
    value         = "1"
    default_value = "0"
  }
}

resource "aws_cloudwatch_metric_alarm" "root_account_usage" {
  alarm_name          = "root-account-usage-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name        = "RootAccountUsageCount"
  namespace          = "SecurityMetrics"
  period             = "300"
  statistic          = "Sum"
  threshold          = "0"
  alarm_description  = "Alert on Root account usage"
  alarm_actions      = [aws_sns_topic.security_alerts.arn]
}
