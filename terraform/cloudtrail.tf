# CloudTrail for API logging
resource "aws_cloudtrail" "security_trail" {
  name                          = "security-monitoring-trail"
  s3_bucket_name               = aws_s3_bucket.cloudtrail_logs.id
  include_global_service_events = true
  is_multi_region_trail        = true
  enable_logging               = true
  enable_log_file_validation   = true
  is_organization_trail        = false

  event_selector {
    read_write_type           = "All"
    include_management_events = true
    
    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3"]
    }
  }
}

# CloudWatch Logs for CloudTrail
resource "aws_cloudwatch_log_group" "cloudtrail_logs" {
  name              = "/aws/cloudtrail/security-monitoring"
  retention_in_days = 90 # Free tier - 90 days retention
}
