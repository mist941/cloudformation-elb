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
