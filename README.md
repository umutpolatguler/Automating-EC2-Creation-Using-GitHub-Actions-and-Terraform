a
# Automating EC2 Creation Using GitHub Actions and Terraform

A step-by-step guide to automate EC2 creation with GitHub Actions and Terraform and ensure that when you change ECS specifications on GitHub, these changes are reflected on AWS via GitHub Actions.
## HOWTO

First, create the Terraform files (`main.tf`, `variables.tf`, `outputs.tf`, `terraform.tfvars`) required to create EC2.

`main.tf`

```hcl
provider "aws" {
	region = var.aws_region
}

resource "aws_instance" "example" {
	ami			  = var.ami_id
	instance_type = var.instance_type
	
	tags = {
		Name = var.instance_name
	}
}
```

`variables.tf`

```hcl
variable "aws_region" {
	type        = string
	description = "The AWS region to create resources in."
}

variable "ami_id" {
	type        = string
	description = "AMI ID for the EC2 instance."
}

variable "instance_type" {
	type        = string
	description = "Type of instance to create."
}

variable "instance_name" {
	type        = string
	description = "Name of the EC2 instance."
}
```

`outputs.tf`

```hcl
output "instance_id" {
	description = "The ID of the EC2 instance"
	value       = aws_instance.example.id
}
```

`terraform.tfvars` (Set the default values in this file. For example, these values create an EC2 instance named "ec2-instance" from the Frankfurt servers which has a type of tf2.micro and uses the AMI "Amazon Linux 2".)

```hcl
aws_region     = "eu-central-1"
ami_id         = "ami-00060fac2f8c42d30"
instance_type  = "t2.micro"
instance_name  = "ec2-instance"
```

After preparing the Terraform files, create a workflow file `(.github/workflows/deploy.yml)` to automate Terraform operations on GitHub Actions.

```yaml
name: TF Deploy EC2

on:
  push:
    branches:
      - main

jobs:
  terraform:
    name: TF Apply
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v2

    - name: Setup TF
      uses: hashicorp/setup-terraform@v1
      with:
        terraform_wrapper: false

    - name: TF Init
      run: terraform init

    - name: TF Apply
      env:
        AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
        AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
      run: terraform apply -auto-approve
```

Add AWS credentials to GitHub Secrets:

- Go to your GitHub repository.

- Follow the path Settings > Secrets and variables > Actions.

- Add AWS credentials with the names `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.

![App Screenshot](https://i.imgur.com/9WJiB5I.png)

When you update the ECS specifications on GitHub (such as `instance_name` in `terraform.tfvars` file), GitHub Actions will run when these changes are pushed to the main branch and the Terraform apply command will be triggered automatically.

![App Screenshot](https://i.imgur.com/MdZQGrT.png)

![App Screeshot](https://i.imgur.com/j13421a.png)
