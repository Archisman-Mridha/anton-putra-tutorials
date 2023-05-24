terraform {
  required_version = "1.4.6"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.67.0"
    }

    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
    archive = {
      source = "hashicorp/archive"
      version = "2.3.0"
    }
  }
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key

  region = var.aws_region

  default_tags {
    tags = {
      "Project": var.project_name
    }
  }
}