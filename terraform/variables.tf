variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "sns_email" {
  description = "Email for SNS alerts"
  type        = string
  sensitive   = true
}
