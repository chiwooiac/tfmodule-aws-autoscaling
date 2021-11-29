terraform {
  required_version = ">= 1.0.0, <= 1.1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.65.0"
    }
  }
}

provider "aws" {
  region                  = "ap-northeast-2"
  profile                 = "terran"
  shared_credentials_file = "$HOME/.aws/credentials"
}

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

