terraform {
  required_version = ">= 0.12.2"

  required_providers {
    local = {
      source = "hashicorp/local"
    }
  }

  backend "s3" {
    bucket         = "sotetsu-lab-v3-terraform-state"
    key            = "terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "sotetsu-lab-v3-terraform-state-lock"
  }
}
