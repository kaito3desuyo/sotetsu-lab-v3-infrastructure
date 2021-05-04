variable "profile" {}
variable "region" {}
variable "name" {}

provider "aws" {
  profile = var.profile
  region  = var.region
}

provider "aws" {
  alias   = "virginia"
  profile = var.profile
  region  = "us-east-1"
}

# You cannot create a new backend by simply defining this and then
# immediately proceeding to "terraform apply". The S3 backend must
# be bootstrapped according to the simple yet essential procedure in
# https://github.com/cloudposse/terraform-aws-tfstate-backend#usage
module "terraform_state_backend" {
  source = "cloudposse/tfstate-backend/aws"
  # Cloud Posse recommends pinning every module to a specific version
  # version     = "x.x.x"
  namespace  = "sotetsu-lab-v3"
  stage      = "default"
  name       = "terraform"
  attributes = ["state"]

  terraform_backend_config_file_path = "."
  terraform_backend_config_file_name = "backend.tf"
  force_destroy                      = false
}


data "aws_acm_certificate" "default" {
  domain      = "*.sotetsu-lab.com"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

data "aws_acm_certificate" "virginia" {
  domain      = "sotetsu-lab.com"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
  provider    = aws.virginia
}

module "vpc" {
  region = var.region
  name   = var.name

  source = "./../../modules/vpc"
}

module "ec2" {
  region = var.region
  name   = var.name

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnet_ids
  acm_arn    = data.aws_acm_certificate.default.arn

  source = "./../../modules/ec2"
}

module "ecs" {
  region = var.region
  name   = var.name

  subnet_ids         = module.vpc.public_subnet_ids
  asg_arn            = module.ec2.api_ec2_asg_arn
  security_group_ids = [module.ec2.api_ec2_security_group_id]
  alb_tg_arn         = module.ec2.api_alb_tg_arn

  source = "./../../modules/ecs"
}
