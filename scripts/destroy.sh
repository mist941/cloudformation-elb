#!/bin/bash

# Usage: ./destroy.sh [stack-name]

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
REGION=${AWS_DEFAULT_REGION:-"us-east-1"}

print_warning "This will destroy the CloudFormation stack: $STACK_NAME"
print_warning "Region: $REGION"

# Confirmation prompt
read -p "Are you sure you want to continue? (yes/no): " -r
if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
    print_status "Operation cancelled."
    exit 0
fi

# Check if stack exists
if ! aws cloudformation describe-stacks --stack-name "$STACK_NAME" --region "$REGION" >/dev/null 2>&1; then
    print_error "Stack does not exist: $STACK_NAME"
    exit 1
fi

print_status "Deleting CloudFormation stack: $STACK_NAME"

aws cloudformation delete-stack \
    --stack-name "$STACK_NAME" \
    --region "$REGION"

print_status "Waiting for stack deletion to complete..."
aws cloudformation wait stack-delete-complete --stack-name "$STACK_NAME" --region "$REGION"

if [ $? -eq 0 ]; then
    print_status "Stack deleted successfully!"
else
    print_error "Stack deletion failed!"
    exit 1
fi
