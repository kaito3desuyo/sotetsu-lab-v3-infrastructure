variable "region" {}
variable "name" {}

variable "vpc_id" {}
variable "public_subnet_ids" {}
variable "private_subnet_ids" {}
variable "ingress_sg_ids" {}
variable "ingress_cidr_blocks" {}
variable "acm_arn" {}

variable "github_repository_name" {}

locals {
  module_name = basename(abspath(path.module))
  module_tags = {
    "Module" = local.module_name
  }
  prefix = "${var.name}-${local.module_name}"
}

locals {
  ecs_cluster_name = "${local.prefix}-ecs-cluster"
  ecs_service_name = "${local.prefix}-ecs-service"
}

locals {
  codepipeline_artifact_bucket_name = "${local.prefix}-codepipeline-artifact"
}
