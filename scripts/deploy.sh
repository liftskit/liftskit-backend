#!/bin/bash

# AWS Deployment Script for Liftskit Backend
# This script builds and deploys the Phoenix application to AWS ECS

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
APP_NAME="liftskit-backend"
AWS_REGION="us-west-2"
ECR_REPOSITORY=""

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
    
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install it first."
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
    ECR_REPOSITORY="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${APP_NAME}"
    print_status "AWS Account ID: ${AWS_ACCOUNT_ID}"
    print_status "ECR Repository: ${ECR_REPOSITORY}"
}

# Build and push Docker image
build_and_push_image() {
    print_status "Building Docker image..."
    
    # Build the image
    docker build -t ${APP_NAME}:latest .
    
    # Tag for ECR
    docker tag ${APP_NAME}:latest ${ECR_REPOSITORY}:latest
    
    # Login to ECR
    print_status "Logging in to Amazon ECR..."
    aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPOSITORY}
    
    # Push the image
    print_status "Pushing image to ECR..."
    docker push ${ECR_REPOSITORY}:latest
    
    print_status "Image pushed successfully!"
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

# Update ECS service
update_ecs_service() {
    print_status "Updating ECS service..."
    
    # Get the cluster name
    CLUSTER_NAME=$(aws ecs list-clusters --query "clusterArns[?contains(@, '${APP_NAME}')]" --output text | cut -d'/' -f2)
    
    if [ -z "$CLUSTER_NAME" ]; then
        print_error "Could not find ECS cluster for ${APP_NAME}"
        exit 1
    fi
    
    # Force new deployment
    aws ecs update-service \
        --cluster ${CLUSTER_NAME} \
        --service ${APP_NAME}-service \
        --force-new-deployment
    
    print_status "ECS service update initiated!"
}

# Wait for deployment to complete
wait_for_deployment() {
    print_status "Waiting for deployment to complete..."
    
    CLUSTER_NAME=$(aws ecs list-clusters --query "clusterArns[?contains(@, '${APP_NAME}')]" --output text | cut -d'/' -f2)
    
    aws ecs wait services-stable \
        --cluster ${CLUSTER_NAME} \
        --services ${APP_NAME}-service
    
    print_status "Deployment completed successfully!"
}

# Get application URL
get_application_url() {
    print_status "Getting application URL..."
    
    cd terraform
    ALB_DNS=$(terraform output -raw alb_dns_name)
    cd ..
    
    print_status "Application is available at: http://${ALB_DNS}"
}

# Main deployment function
main() {
    print_status "Starting deployment of ${APP_NAME} to AWS..."
    
    check_dependencies
    get_aws_account_id
    
    # Check if this is the first deployment
    if [ ! -f "terraform/terraform.tfvars" ]; then
        print_warning "terraform.tfvars not found. Please create it from terraform.tfvars.example first."
        print_warning "You'll need to set up your database password and secret key base."
        exit 1
    fi
    
    # Deploy infrastructure (only if needed)
    if [ "$1" = "--infrastructure" ] || [ ! -d "terraform/.terraform" ]; then
        deploy_infrastructure
    fi
    
    build_and_push_image
    update_ecs_service
    wait_for_deployment
    get_application_url
    
    print_status "Deployment completed successfully! 🎉"
}

# Run main function with all arguments
main "$@"
