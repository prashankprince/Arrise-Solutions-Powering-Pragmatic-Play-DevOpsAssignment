terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  alias   = "account_a"
  region  = "us-east-1"
  profile = "account-a"
}

provider "aws" {
  alias   = "account_b"
  region  = "us-east-1"
  profile = "account-b"
}
