#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install a package
install_package() {
    echo "Installing $1..."
    sudo apt-get update && sudo apt-get install -y $1
    if [ $? -eq 0 ]; then
        echo "$1 installed successfully."
    else
        echo "Failed to install $1. Please install it manually."
        exit 1
    fi
}

echo "Checking and installing prerequisites..."

# Check and install Terraform
if ! command_exists terraform; then
    echo "Terraform not found. Installing..."
    sudo apt-get update && sudo apt-get install -y software-properties-common
    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt-get update && sudo apt-get install terraform
    if [ $? -eq 0 ]; then
        echo "Terraform installed successfully."
    else
        echo "Failed to install Terraform. Please install it manually."
        exit 1
    fi
else
    echo "Terraform is already installed."
fi

# Check and install AWS CLI
if ! command_exists aws; then
    echo "AWS CLI not found. Installing..."
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    rm -rf aws awscliv2.zip
    if [ $? -eq 0 ]; then
        echo "AWS CLI installed successfully."
    else
        echo "Failed to install AWS CLI. Please install it manually."
        exit 1
    fi
else
    echo "AWS CLI is already installed."
fi

# Check and install Docker
if ! command_exists docker; then
    echo "Docker not found. Installing..."
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt-get install -y docker-ce
    if [ $? -eq 0 ]; then
        echo "Docker installed successfully."
    else
        echo "Failed to install Docker. Please install it manually."
        exit 1
    fi
else
    echo "Docker is already installed."
fi

# Check and install npm
if ! command_exists npm; then
    echo "npm not found. Installing Node.js and npm..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs
    if [ $? -eq 0 ]; then
        echo "Node.js and npm installed successfully."
    else
        echo "Failed to install Node.js and npm. Please install them manually."
        exit 1
    fi
else
    echo "npm is already installed."
fi

echo "All prerequisites are installed."

# Set AWS credentials
echo "Setting AWS credentials..."
read -p "Enter your AWS Access Key ID: " aws_access_key
read -p "Enter your AWS Secret Access Key: " aws_secret_key
read -p "Enter your 12-digit AWS Account ID: " aws_account_id

export AWS_ACCESS_KEY_ID="$aws_access_key"
export AWS_SECRET_ACCESS_KEY="$aws_secret_key"

echo "AWS credentials set successfully."

# Validate AWS Account ID
if [! $aws_account_id =~ ^[0-9]{12}$]; then
    echo "Error: Invalid AWS Account ID. It should be a 12-digit number."
    exit 1
fi

# Change working directory
echo "Changing to the infrastructure directory..."
cd infrastructure/aws/

# Initialize Terraform
echo "Initializing Terraform..."
terraform init

if [ $? -eq 0 ]; then
    echo "Terraform initialized successfully."
else
    echo "Failed to initialize Terraform. Please check your configuration and try again."
    exit 1
fi

# Apply Terraform plan
echo "Applying Terraform plan..."
terraform apply -var "account_id=$aws_account_id" -auto-approve

if [ $? -eq 0 ]; then
    echo "Terraform apply completed successfully."
else
    echo "Terraform apply failed. Please check the error messages and try again."
    exit 1
fi

echo "Infrastructure setup complete!"