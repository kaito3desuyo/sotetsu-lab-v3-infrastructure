data "aws_region" "current" {}

variable "name" {}
variable "vpc_id" {}
variable "public_subnet_ids" {}
variable "private_subnet_ids" {}
variable "acm_arn" {}
variable "github_repository_name" {}

locals {
  module_name = basename(abspath(path.module))
  module_tags = {
    "Module" = local.module_name
  }
  prefix         = "${var.name}-${local.module_name}"
  region         = data.aws_region.current.name
  container_name = local.module_name
  container_port = 3000
}

locals {
  ecs_taskdef_family = "${local.prefix}-ecs-taskdef"
  ecs_taskdef_json = jsonencode([
    {
      "name"      = local.container_name
      "image"     = "traefik/whoami:latest"
      "essential" = true
      "portMappings" = [
        {
          "protocol"      = "tcp"
          "containerPort" = local.container_port
        }
      ]
      "environment" = [
        {
          "name"  = "WHOAMI_PORT_NUMBER"
          "value" = tostring(local.container_port)
        }
      ]
      "secrets" = []
      "logConfiguration" = {
        "logDriver" = "awslogs"
        "options" = {
          "awslogs-region"        = local.region
          "awslogs-group"         = aws_cloudwatch_log_group.for_ecs.name
          "awslogs-stream-prefix" = local.cloudwatch_log_stream_prefix
        }
      }
    }
  ])
  ecs_cluster_name                    = "${local.prefix}-ecs-cluster"
  ecs_service_name                    = "${local.prefix}-ecs-service"
  ecs_task_role_name                  = "${local.prefix}-ecs-task-role"
  ecs_task_role_policy_name           = "${local.prefix}-ecs-task-role-policy"
  ecs_task_execution_role_name        = "${local.prefix}-ecs-task-execution-role"
  ecs_task_execution_role_policy_name = "${local.prefix}-ecs-task-execution-role-policy"
}

locals {
  cloudwatch_log_group_name     = "/aws/ecs/${local.prefix}"
  cloudwatch_log_group_tag_name = "${local.prefix}-ecs-log"
  cloudwatch_log_stream_prefix  = "/${local.ecs_taskdef_family}"
}

locals {
  codedeploy_application_name      = "${local.prefix}-codedeploy-application"
  codedeploy_deployment_group_name = "${local.prefix}-codedeploy-deployment-group"
  codedeploy_role_name             = "${local.prefix}-codedeploy-role"
}
