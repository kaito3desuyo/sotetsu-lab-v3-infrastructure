data "aws_ecs_task_definition" "for_api_ecs" {
  task_definition = "${var.name}-api"
}

resource "aws_ecs_cluster" "for_api" {
  name               = "${var.name}-api-ecs-cluster"
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  setting {
    name  = "containerInsights"
    value = "disabled"
  }

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    base              = 0
    weight            = 1
  }

  tags = {
    "Name" = "${var.name}-api-ecs-cluster"
  }
}

resource "aws_ecs_service" "for_api" {
  name                               = "${var.name}-api-ecs-service"
  cluster                            = aws_ecs_cluster.for_api.id
  task_definition                    = "${data.aws_ecs_task_definition.for_api_ecs.family}:${data.aws_ecs_task_definition.for_api_ecs.revision}"
  desired_count                      = 4
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 50
  health_check_grace_period_seconds  = 60
  scheduling_strategy                = "REPLICA"
  propagate_tags                     = "TASK_DEFINITION"
  # enable_execute_command             = true

  network_configuration {
    assign_public_ip = false
    subnets          = var.private_subnet_ids
    security_groups  = [aws_security_group.for_api_ec2.id]
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

  lifecycle {
    ignore_changes = [
      desired_count,
      task_definition,
      load_balancer
    ]
  }
}
