terraform {
  required_version = ">= 0.12.2"

  backend "s3" {
    region         = "ap-northeast-1"
    bucket         = "sotetsu-lab-v3-default-terraform-state"
    key            = "terraform.tfstate"
    dynamodb_table = "sotetsu-lab-v3-default-terraform-state-lock"
    profile        = ""
    role_arn       = ""
    encrypt        = "true"
  }
}
