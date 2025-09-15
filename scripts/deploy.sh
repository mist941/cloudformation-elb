#!/bin/bash

# Usage: ./deploy.sh [stack-name]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

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

STACK_NAME=${1:-"simple-alb-stack"}
TEMPLATE_FILE="templates/elb.yaml"
PARAMETERS_FILE="parameters.json"
REGION=${AWS_DEFAULT_REGION:-"eu-north-1"}

# Check if files exist
if [ ! -f "$TEMPLATE_FILE" ]; then
    print_error "Template file not found: $TEMPLATE_FILE"
    exit 1
fi

if [ ! -f "$PARAMETERS_FILE" ]; then
    print_error "Parameters file not found: $PARAMETERS_FILE"
    exit 1
fi

print_status "Deploying CloudFormation stack: $STACK_NAME"
print_status "Region: $REGION"
print_status "Template: $TEMPLATE_FILE"
print_status "Parameters: $PARAMETERS_FILE"

# Check if stack exists
if aws cloudformation describe-stacks --stack-name "$STACK_NAME" --region "$REGION" --no-cli-pager >/dev/null 2>&1; then
    print_status "Stack exists, updating..."
    aws cloudformation update-stack \
        --stack-name "$STACK_NAME" \
        --template-body "file://$TEMPLATE_FILE" \
        --parameters "file://$PARAMETERS_FILE" \
        --region "$REGION" \
        --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
        --no-cli-pager
    
    print_status "Waiting for stack update to complete..."
    aws cloudformation wait stack-update-complete --stack-name "$STACK_NAME" --region "$REGION" --no-cli-pager
else
    print_status "Stack does not exist, creating..."
    aws cloudformation create-stack \
        --stack-name "$STACK_NAME" \
        --template-body "file://$TEMPLATE_FILE" \
        --parameters "file://$PARAMETERS_FILE" \
        --region "$REGION" \
        --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
        --no-cli-pager
    
    print_status "Waiting for stack creation to complete..."
    aws cloudformation wait stack-create-complete --stack-name "$STACK_NAME" --region "$REGION" --no-cli-pager
fi

if [ $? -eq 0 ]; then
    print_status "Stack operation completed successfully!"
    
    # Display outputs
    print_status "Stack outputs:"
    aws cloudformation describe-stacks \
        --stack-name "$STACK_NAME" \
        --region "$REGION" \
        --query 'Stacks[0].Outputs' \
        --output table \
        --no-cli-pager
else
    print_error "Stack operation failed!"
    exit 1
fi
