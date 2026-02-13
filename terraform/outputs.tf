output "s3_bucket_name" {
  description = "Name of the S3 bucket for log archive"
  value       = aws_s3_bucket.cloudtrail_logs.id
}

output "guardduty_detector_id" {
  description = "ID of the GuardDuty detector"
  value       = aws_guardduty_detector.main.id
}

output "sns_topic_arn" {
  description = "ARN of the SNS topic for alerts"
  value       = aws_sns_topic.security_alerts.arn
}

output "cloudtrail_arn" {
  description = "ARN of the CloudTrail trail"
  value       = aws_cloudtrail.security_trail.arn
}
