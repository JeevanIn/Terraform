terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.64.0"
    }
  }
}


terraform {
  backend "s3" {
    bucket   = "jeevan1055-terraform"
    key      = "501"
    dynamodb_table = "jeevan-lock"
  }
  }


provider "aws" { # Configuration options
  region = "ap-southeast-1"
}


