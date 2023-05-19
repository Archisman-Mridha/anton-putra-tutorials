variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

variable "aws_region" {
  default = "us-east-2"
}

variable "source_instance_type" {
  default = "t3.small"
}

variable "source_subnet_id" {
  type = string
  description = "Subnet ID where the source instance will be launched"
}

variable "project_name" {
  type = string
}