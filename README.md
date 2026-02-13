# AWS Security Monitoring Platform

A comprehensive AWS-native security monitoring solution that detects, alerts on, and logs potential security threats using **Amazon GuardDuty**, **CloudTrail**, **CloudWatch**, and **SNS**. The project includes automated attack simulations to demonstrate real-world threat detection capabilities.

![Architecture Diagram](architecture.png)
<!-- If you later add a live badge or status, place it here e.g.:
[![Terraform Version](https://img.shields.io/badge/Terraform-%3E%3D1.0-blue)](https://www.terraform.io)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE) -->

## ✨ Features

### Security Monitoring
- ✅ Multi-region **AWS CloudTrail** for comprehensive API activity logging
- ✅ **Amazon GuardDuty** intelligent threat detection (malware, reconnaissance, crypto mining, etc.)
- ✅ Real-time **CloudWatch** metrics, filters & alarms
- ✅ Email / SMS notifications via **Amazon SNS**
- ✅ Encrypted **S3** bucket for long-term secure log archiving
- ✅ 90-day log retention (optimized for AWS Free Tier)

### Attack Simulations (via Ansible)
Demonstrates detection of common threat patterns:
- Port scanning & reconnaissance
- Unauthorized / brute-force access attempts
- Cryptocurrency mining activity
- Backdoor / C2 (command & control) communication patterns
- Privilege escalation attempts
- Root / privileged account usage monitoring

## 🏗️ Architecture

![Architecture Diagram](architecture.png)

### Core AWS Components
- **Amazon GuardDuty** → ML-based threat intelligence & anomaly detection
- **AWS CloudTrail** → Audit & API logging (management + data events)
- **Amazon CloudWatch** → Metric filters, alarms & dashboards
- **Amazon SNS** → Notification delivery (email, SMS, Lambda, etc.)
- **Amazon S3** → Encrypted storage for logs & findings exports
- **AWS IAM** → Least-privilege roles & policies

## 🛠️ Technologies

- **Terraform** ≥ 1.0 — Infrastructure as Code
- **Ansible** ≥ 2.9 — Attack simulation orchestration
- **AWS Free Tier** eligible services (cost-conscious design)
- **Git** — Version control & collaboration

## 🚀 Quick Start

### Prerequisites

Install and configure these tools:

```bash
# AWS CLI (configured with credentials)
aws --version

# Terraform >= 1.0
terraform --version

# Ansible >= 2.9
ansible --version

# jq (for JSON parsing in scripts)
jq --version