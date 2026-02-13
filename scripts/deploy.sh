#!/bin/bash

echo "��� Starting Security Monitoring Platform Deployment..."

# Set variables
PROJECT_DIR=~/aws-terraform-portfolio/security-monitoring
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="$PROJECT_DIR/deployment_$TIMESTAMP.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}" | tee -a "$LOG_FILE"
    exit 1
}

warning() {
    echo -e "${YELLOW}[WARNING] $1${NC}" | tee -a "$LOG_FILE"
}

# Check prerequisites
check_prerequisites() {
    log "Checking prerequisites..."
    
    command -v terraform >/dev/null 2>&1 || error "Terraform is not installed"
    command -v ansible >/dev/null 2>&1 || error "Ansible is not installed"
    command -v aws >/dev/null 2>&1 || error "AWS CLI is not installed"
    
    # Check AWS credentials
    aws sts get-caller-identity >/dev/null 2>&1 || error "AWS credentials not configured"
    
    log "✅ Prerequisites check passed"
}

# Deploy Terraform infrastructure
deploy_terraform() {
    log "Deploying Terraform infrastructure..."
    
    cd "$PROJECT_DIR/terraform"
    
    # Initialize Terraform
    terraform init || error "Terraform init failed"
    
    # Format Terraform files
    terraform fmt -recursive
    
    # Validate Terraform configuration
    terraform validate || error "Terraform validation failed"
    
    # Create Terraform plan
    terraform plan -out="plan.tfplan" || error "Terraform plan failed"
    
    # Apply Terraform configuration
    terraform apply "plan.tfplan" || error "Terraform apply failed"
    
    # Save outputs
    terraform output -json > "../terraform-outputs.json"
    
    log "✅ Terraform deployment completed"
}

# Configure Ansible
configure_ansible() {
    log "Configuring Ansible..."
    
    cd "$PROJECT_DIR/ansible"
    
    # Install Ansible collections
    ansible-galaxy collection install -r requirements.yml || warning "Failed to install Ansible collections"
    
    # Get Terraform outputs for Ansible
    DETECTOR_ID=$(jq -r '.guardduty_detector_id.value' "../terraform-outputs.json")
    
    # Update Ansible vars file
    cat > "vars/aws_credentials.yml" << EOF
---
aws_access_key: $(aws configure get aws_access_key_id)
aws_secret_key: $(aws configure get aws_secret_access_key)
guardduty_detector_id: $DETECTOR_ID
EOF
    
    log "✅ Ansible configured"
}

# Simulate attacks
simulate_attacks() {
    log "Starting attack simulation..."
    
    cd "$PROJECT_DIR/ansible"
    
    # Run all attack simulations
    ansible-playbook attack-simulation.yml \
        --tags "recon,unauthorized,crypto,backdoor" \
        -v
    
    log "✅ Attack simulation completed"
}

# Monitor and verify
verify_monitoring() {
    log "Verifying monitoring setup..."
    
    # Check GuardDuty status
    DETECTOR_ID=$(jq -r '.guardduty_detector_id.value' "$PROJECT_DIR/terraform-outputs.json")
    
    # Wait for findings to appear
    warning "Waiting 2 minutes for GuardDuty findings to generate..."
    sleep 120
    
    # Get GuardDuty findings
    FINDINGS_COUNT=$(aws guardduty list-findings \
        --detector-id "$DETECTOR_ID" \
        --region us-east-1 \
        --query 'length(FindingIds)' \
        --output text)
    
    if [ "$FINDINGS_COUNT" -gt 0 ]; then
        log "✅ GuardDuty detected $FINDINGS_COUNT findings"
        
        # Get latest finding
        aws guardduty list-findings \
            --detector-id "$DETECTOR_ID" \
            --region us-east-1 \
            --max-results 1 \
            --output table
    else
        warning "No GuardDuty findings detected yet"
    fi
    
    # Check CloudWatch alarms
    ALARM_STATE=$(aws cloudwatch describe-alarms \
        --alarm-names "guardduty-critical-finding" \
        --query 'MetricAlarms[0].StateValue' \
        --output text)
    
    log "CloudWatch Alarm State: $ALARM_STATE"
}

# Cleanup resources
cleanup() {
    log "Starting cleanup..."
    
    cd "$PROJECT_DIR/terraform"
    
    # Destroy Terraform resources
    terraform destroy -auto-approve || error "Terraform destroy failed"
    
    # Cleanup S3 bucket (force delete)
    BUCKET_NAME=$(jq -r '.s3_bucket_name.value' "../terraform-outputs.json")
    aws s3 rb "s3://$BUCKET_NAME" --force || warning "Failed to delete S3 bucket"
    
    log "✅ Cleanup completed"
}

# Main execution
main() {
    log "=== Security Monitoring Platform Deployment ==="
    
    case "$1" in
        deploy)
            check_prerequisites
            deploy_terraform
            configure_ansible
            simulate_attacks
            verify_monitoring
            ;;
        cleanup)
            cleanup
            ;;
        full)
            check_prerequisites
            deploy_terraform
            configure_ansible
            simulate_attacks
            verify_monitoring
            read -p "Press Enter to cleanup resources..."
            cleanup
            ;;
        *)
            echo "Usage: $0 {deploy|cleanup|full}"
            exit 1
            ;;
    esac
    
    log "=== Deployment Complete ==="
}

main "$@"
