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