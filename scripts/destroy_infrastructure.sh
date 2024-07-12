#!/bin/bash

echo "Setting AWS credentials..."
read -p "Enter your AWS Access Key ID: " aws_access_key
read -p "Enter your AWS Secret Access Key: " aws_secret_key
read -p "Enter your 12-digit AWS Account ID: " aws_account_id

export AWS_ACCESS_KEY_ID="$aws_access_key"
export AWS_SECRET_ACCESS_KEY="$aws_secret_key"

# Validate AWS Account ID
if ! echo "$aws_account_id" | grep -Eq '^[0-9]{12}$'; then
    echo "Error: Invalid AWS Account ID. It should be a 12-digit number."
    exit 1
fi

# Change working directory to the infrastructure directory
echo "Changing to the infrastructure directory..."
cd infrastructure/aws/ || { echo "Infrastructure directory not found"; exit 1; }

# Destroy Terraform-managed infrastructure
echo "Destroying Terraform-managed infrastructure..."
terraform destroy -var "account_id=$aws_account_id" -auto-approve

if [ $? -eq 0 ]; then
    echo "Terraform destroy completed successfully."
else
    echo "Terraform destroy failed. Please check the error messages and try again."
    exit 1
fi

echo "Infrastructure teardown complete!"
