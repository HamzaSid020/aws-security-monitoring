# IAM role for CloudTrail
resource "aws_iam_role" "cloudtrail_role" {
  name = "cloudtrail-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "cloudtrail_policy" {
  name = "cloudtrail-cloudwatch-policy"
  role = aws_iam_role.cloudtrail_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "${aws_cloudwatch_log_group.cloudtrail_logs.arn}:*"
      }
    ]
  })
}

# IAM role for Security Analysis (Ansible will use this)
resource "aws_iam_role" "security_analyst" {
  name = "security-analyst-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = data.aws_caller_identity.current.arn
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "security_analyst_policy" {
  name = "security-analyst-policy"
  role = aws_iam_role.security_analyst.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "guardduty:ListFindings",
          "guardduty:GetFindings",
          "cloudtrail:LookupEvents",
          "logs:DescribeLogGroups",
          "logs:FilterLogEvents",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = "*"
      }
    ]
  })
}
