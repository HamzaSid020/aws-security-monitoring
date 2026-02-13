# í´’ AWS Security Monitoring Platform

## í³‹ Project Overview
A comprehensive AWS security monitoring solution that detects, alerts, and logs security threats using GuardDuty, CloudTrail, CloudWatch, and SNS. The system simulates real-world attack scenarios to demonstrate threat detection capabilities.

## í¿—ï¸ Architecture
![Architecture Diagram](architecture.png)

### Components
- **AWS GuardDuty** - Intelligent threat detection service
- **AWS CloudTrail** - API activity logging
- **AWS CloudWatch** - Metrics and alarming
- **AWS SNS** - Email notifications
- **S3** - Secure log archive
- **IAM** - Role-based access control

## í» ï¸ Technologies Used
- **Terraform** - Infrastructure as Code
- **Ansible** - Attack simulation automation
- **AWS Free Tier** - Cost-effective deployment
- **Git** - Version control

## í³Š Features
### Security Monitoring
- âœ… Multi-region CloudTrail for API logging
- âœ… GuardDuty for threat detection
- âœ… Real-time CloudWatch alarms
- âœ… Email alerts via SNS
- âœ… Encrypted S3 log archive
- âœ… 90-day log retention (Free Tier optimized)

### Attack Simulations
- í´´ Port scanning detection
- í´´ Unauthorized access attempts
- í´´ Crypto mining activity simulation
- í´´ Backdoor communication patterns
- í´´ Privilege escalation attempts
- í´´ Root account usage monitoring

## íº€ Quick Start

### Prerequisites
```bash
# Required tools
- AWS CLI configured
- Terraform >= 1.0
- Ansible >= 2.9
- jq
