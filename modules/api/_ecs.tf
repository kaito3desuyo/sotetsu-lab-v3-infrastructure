data "aws_ecs_task_definition" "for_api_ecs" {
  task_definition = "${var.name}-api"
}

resource "aws_ecs_cluster" "for_api" {
  name = local.ecs_cluster_name

  setting {
    name  = "containerInsights"
    value = "disabled"
  }

  tags = {
    "Name" = local.ecs_cluster_name
  }
}

resource "aws_ecs_cluster_capacity_providers" "for_api" {
  cluster_name       = aws_ecs_cluster.for_api.name
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    base              = 0
    weight            = 1
  }
}

resource "aws_ecs_service" "for_api" {
  name                               = local.ecs_service_name
  cluster                            = aws_ecs_cluster.for_api.id
  task_definition                    = "${data.aws_ecs_task_definition.for_api_ecs.family}:${data.aws_ecs_task_definition.for_api_ecs.revision}"
  desired_count                      = 4
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 50
  health_check_grace_period_seconds  = 60
  propagate_tags                     = "TASK_DEFINITION"
  # enable_execute_command             = true

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.for_api_ec2.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.for_api_blue.arn
    container_name   = "${var.name}-api"
    container_port   = 3000
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    base              = 0
    weight            = 1
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  tags = {
    "Name" = local.ecs_service_name
  }

  lifecycle {
    ignore_changes = [
      desired_count,
      task_definition,
      load_balancer
    ]
  }
}
