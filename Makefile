# Simple CloudFormation ALB Project Makefile

.PHONY: help validate deploy destroy clean

# Default target
help:
	@echo "Available targets:"
	@echo "  validate  - Validate CloudFormation template"
	@echo "  deploy    - Deploy the stack"
	@echo "  destroy   - Destroy the stack"
	@echo "  clean     - Clean temporary files"

# Validate template
validate:
	@echo "Validating CloudFormation template..."
	@aws cloudformation validate-template --template-body file://templates/elb.yaml

# Deploy stack
deploy:
	@echo "Deploying CloudFormation stack..."
	@./scripts/deploy.sh

# Destroy stack
destroy:
	@echo "Destroying CloudFormation stack..."
	@./scripts/destroy.sh

# Clean temporary files
clean:
	@echo "Cleaning temporary files..."
	@find . -name "*.swp" -delete
	@find . -name "*.swo" -delete
	@find . -name "*~" -delete
	@find . -name "*.tmp" -delete
	@find . -name "*.temp" -delete
