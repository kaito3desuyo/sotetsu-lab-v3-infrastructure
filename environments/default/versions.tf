terraform {
  required_version = "~> 1.3.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.37.0"
    }
  }

  backend "s3" {
    bucket         = "sotetsu-lab-v3-terraform-state"
    key            = "terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "sotetsu-lab-v3-terraform-state-lock"
  }
}

provider "aws" {
  region = local.region

  default_tags {
    tags = {
      "System"    = local.system
      "Terraform" = "true"
    }
  }
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}
