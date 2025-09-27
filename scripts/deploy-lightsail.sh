#!/bin/bash

# AWS Lightsail Deployment Script for Liftskit Backend
# This script deploys the Phoenix application to AWS Lightsail (most cost-effective option)

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
APP_NAME="liftskit-backend"
AWS_REGION="us-west-2"

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if required tools are installed
check_dependencies() {
    print_status "Checking dependencies..."
    
    if ! command -v aws &> /dev/null; then
        print_error "AWS CLI is not installed. Please install it first."
        exit 1
    fi
    
    if ! command -v terraform &> /dev/null; then
        print_error "Terraform is not installed. Please install it first."
        exit 1
    fi
    
    print_status "All dependencies are installed."
}

# Get AWS Account ID
get_aws_account_id() {
    print_status "Getting AWS Account ID..."
    AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
    print_status "AWS Account ID: ${AWS_ACCOUNT_ID}"
}

# Deploy infrastructure with Terraform
deploy_infrastructure() {
    print_status "Deploying infrastructure with Terraform..."
    
    cd terraform
    
    # Initialize Terraform
    print_status "Initializing Terraform..."
    terraform init
    
    # Plan the deployment
    print_status "Planning Terraform deployment..."
    terraform plan -var="aws_account_id=${AWS_ACCOUNT_ID}"
    
    # Apply the changes
    print_status "Applying Terraform changes..."
    terraform apply -var="aws_account_id=${AWS_ACCOUNT_ID}" -auto-approve
    
    cd ..
    
    print_status "Infrastructure deployed successfully!"
}

# Get application URL
get_application_url() {
    print_status "Getting application URL..."
    
    cd terraform
    STATIC_IP=$(terraform output -raw static_ip_address)
    cd ..
    
    print_status "Application will be available at: http://${STATIC_IP}"
    print_warning "Note: It may take a few minutes for the application to start up."
    print_warning "You'll need to upload your Docker image to the Lightsail instance manually."
}

# Show deployment instructions
show_deployment_instructions() {
    print_status "Deployment Instructions:"
    echo ""
    echo "1. Your Lightsail instance is now running at: http://${STATIC_IP}"
    echo ""
    echo "2. To deploy your application:"
    echo "   a. Build your Docker image locally:"
    echo "      docker build -t ${APP_NAME}:latest ."
    echo ""
    echo "   b. Save the image to a tar file:"
    echo "      docker save ${APP_NAME}:latest -o ${APP_NAME}.tar"
    echo ""
    echo "   c. Upload the image to your Lightsail instance:"
    echo "      scp ${APP_NAME}.tar ubuntu@${STATIC_IP}:/opt/${APP_NAME}/"
    echo ""
    echo "   d. SSH into your Lightsail instance:"
    echo "      ssh ubuntu@${STATIC_IP}"
    echo ""
    echo "   e. Load and run the Docker image:"
    echo "      cd /opt/${APP_NAME}"
    echo "      docker load -i ${APP_NAME}.tar"
    echo "      ./deploy.sh"
    echo ""
    echo "3. Your application will be available at: http://${STATIC_IP}"
    echo ""
    # Check if using local database
    if grep -q "use_local_database = true" terraform/terraform.tfvars 2>/dev/null; then
        print_status "Total monthly cost: $3.50 (Lightsail Nano only - ultra cost-effective!)"
    else
        print_status "Total monthly cost: $6.50 (Lightsail Nano + RDS t4g.micro)"
    fi
}

# Main deployment function
main() {
    print_status "Starting deployment of ${APP_NAME} to AWS Lightsail..."
    print_status "Ultra cost-effective options available:"
    print_status "  - $3.50/month: Lightsail Nano + Local PostgreSQL"
    print_status "  - $6.50/month: Lightsail Nano + RDS t4g.micro"
    
    check_dependencies
    get_aws_account_id
    
    # Check if this is the first deployment
    if [ ! -f "terraform/terraform.tfvars" ]; then
        print_warning "terraform.tfvars not found. Please create it from terraform.tfvars.example first."
        print_warning "You'll need to set up your database password and secret key base."
        exit 1
    fi
    
    deploy_infrastructure
    get_application_url
    show_deployment_instructions
    
    print_status "Lightsail deployment completed successfully! 🎉"
    print_status "Cost: ~$18/month (vs $18/month on Fly.io, but with better performance)"
}

# Run main function with all arguments
main "$@"
