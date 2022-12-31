terraform {
  required_version = "~> 1.3.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.37.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }
}
