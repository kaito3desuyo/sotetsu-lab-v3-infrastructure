variable "profile" {}
variable "region" {}
variable "name" {}
variable "my_ip" {}
variable "bastion_cidr_block" {}
variable "main_db_username" {}
variable "main_db_password" {}

variable "bff_domain_name" {}

provider "aws" {
  profile = var.profile
  region  = var.region
}

provider "aws" {
  alias   = "virginia"
  profile = var.profile
  region  = "us-east-1"
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

module "keypair" {
  name = var.name

  source = "./../../modules/keypair"
}

module "network" {
  region = var.region
  name   = var.name

  cidr_block         = "10.0.0.0/16"
  bastion_cidr_block = var.bastion_cidr_block
  keypair_id         = module.keypair.keypair_id

  source = "./../../modules/network"
}

module "database" {
  region = var.region
  name   = var.name

  vpc_id              = module.network.vpc_id
  subnet_ids          = module.network.db_subnet_ids
  ingress_sg_ids      = [module.api.api_ec2_security_group_id]
  ingress_cidr_blocks = [var.bastion_cidr_block]
  main_db_username    = var.main_db_username
  main_db_password    = var.main_db_password

  source = "./../../modules/database"
}

module "api" {
  region = var.region
  name   = var.name

  vpc_id              = module.network.vpc_id
  public_subnet_ids   = module.network.public_subnet_ids
  private_subnet_ids  = module.network.private_subnet_ids
  ingress_sg_ids      = []
  ingress_cidr_blocks = [var.bastion_cidr_block]
  acm_arn             = data.aws_acm_certificate.default.arn

  github_repository_name = "kaito3desuyo/sotetsu-lab-v3-api"

  source = "./../../modules/api"
}

module "web" {
  region = var.region
  name   = var.name

  acm_arn         = data.aws_acm_certificate.virginia.arn
  bff_domain_name = var.bff_domain_name

  github_repository_name = "kaito3desuyo/sotetsu-lab-v3-client"

  source = "./../../modules/web"
}
