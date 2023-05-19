variable "project_name" {
  default = "create-aws-alb"
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

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "aws_instance_type" {
  default = "t3.small"
}
