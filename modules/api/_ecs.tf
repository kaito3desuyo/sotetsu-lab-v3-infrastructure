# data "aws_ecs_task_definition" "for_api" {
#   task_definition = local.ecs_taskdef_family
# }

# resource "aws_ecs_task_definition" "for_api" {
#   family                   = local.ecs_taskdef_family
#   cpu                      = "256"
#   memory                   = "512"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   task_role_arn            = aws_iam_role.ecs_task_role.arn
#   execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
#   container_definitions    = local.ecs_taskdef_json

#   tags = merge(
#     local.module_tags,
#     {
#       "Name" = local.ecs_taskdef_family
#     }
#   )

#   lifecycle {
#     ignore_changes = [
#       cpu,
#       memory,
#       task_role_arn,
#       execution_role_arn,
#       container_definitions
#     ]
#   }
# }

# resource "aws_ecs_cluster" "for_api" {
#   name = local.ecs_cluster_name

#   setting {
#     name  = "containerInsights"
#     value = "disabled"
#   }

#   tags = merge(
#     local.module_tags,
#     {
#       "Name" = local.ecs_cluster_name
#     }
#   )
# }

# resource "aws_ecs_cluster_capacity_providers" "for_api" {
#   cluster_name       = aws_ecs_cluster.for_api.name
#   capacity_providers = ["FARGATE", "FARGATE_SPOT"]

#   default_capacity_provider_strategy {
#     capacity_provider = "FARGATE_SPOT"
#     base              = 0
#     weight            = 1
#   }
# }

# resource "aws_ecs_service" "for_api" {
#   name                               = local.ecs_service_name
#   cluster                            = aws_ecs_cluster.for_api.id
#   task_definition                    = "${aws_ecs_task_definition.for_api.family}:${max(aws_ecs_task_definition.for_api.revision, data.aws_ecs_task_definition.for_api.revision)}"
#   desired_count                      = 4
#   health_check_grace_period_seconds  = 60
#   deployment_maximum_percent         = 100
#   deployment_minimum_healthy_percent = 50
#   propagate_tags                     = "TASK_DEFINITION"
#   # enable_execute_command             = true

#   network_configuration {
#     subnets          = var.private_subnet_ids
#     security_groups  = [aws_security_group.for_api_ec2.id]
#     assign_public_ip = false
#   }

#   load_balancer {
#     target_group_arn = aws_lb_target_group.for_api_blue.arn
#     container_name   = local.container_name
#     container_port   = local.container_port
#   }

#   deployment_controller {
#     type = "CODE_DEPLOY"
#   }

#   tags = merge(
#     local.module_tags,
#     {
#       "Name" = local.ecs_service_name
#     }
#   )

#   lifecycle {
#     ignore_changes = [
#       task_definition,
#       desired_count,
#       load_balancer,
#       capacity_provider_strategy
#     ]
#   }
# }
