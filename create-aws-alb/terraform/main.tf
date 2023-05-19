terraform {
  required_version = "1.4.6"

  backend "local" {}

  required_providers {

    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "4.67.0"
    }
  }
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key

  region = var.aws_region

  default_tags {
    tags = {
      project = var.project_name
    }
  }
}
