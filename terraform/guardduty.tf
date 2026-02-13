# Enable GuardDuty
resource "aws_guardduty_detector" "main" {
  enable = true
  
  datasources {
    s3_logs {
      enable = true
    }
    kubernetes {
      audit_logs {
        enable = true
      }
    }
    malware_protection {
      scan_ec2_instance_with_findings {
        ebs_volumes {
          enable = true
        }
      }
    }
  }
}

# Sample finding generator for testing
resource "aws_guardduty_detector" "main" {
  # This is already defined above
}

# IAM role for GuardDuty to publish findings
resource "aws_iam_role" "guardduty_publishing" {
  name = "guardduty-publishing-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "guardduty.amazonaws.com"
        }
      }
    ]
  })
}
