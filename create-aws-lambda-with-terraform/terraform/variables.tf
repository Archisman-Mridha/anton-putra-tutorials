variable "project_name" {
  default = "create-aws-lambda-with-terraform"
}

variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

variable "aws_region" {
  default = "us-east-2"
}

variable "aws_zone" {
  default = "us-east-2a"
}

variable "aws_instance_type" {
  default = "t3.micro"
}
