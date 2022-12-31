resource "aws_codedeploy_app" "for_api" {
  name             = local.codedeploy_application_name
  compute_platform = "ECS"

  tags = merge(
    local.module_tags,
    {
      "Name" = local.codedeploy_application_name
    }
  )
}

resource "aws_codedeploy_deployment_group" "for_api" {
  app_name               = local.codedeploy_application_name
  deployment_group_name  = local.codedeploy_deployment_group_name
  service_role_arn       = aws_iam_role.codedeploy_role.arn
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"

  ecs_service {
    cluster_name = aws_ecs_cluster.for_api.name
    service_name = aws_ecs_service.for_api.name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [aws_lb_listener.for_api_production.arn]
      }

      test_traffic_route {
        listener_arns = [aws_lb_listener.for_api_test.arn]
      }

      target_group {
        name = aws_lb_target_group.for_api_blue.name
      }

      target_group {
        name = aws_lb_target_group.for_api_green.name
      }
    }
  }

  deployment_style {
    deployment_type   = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout    = "STOP_DEPLOYMENT"
      wait_time_in_minutes = 1440
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 60
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  tags = merge(
    local.module_tags,
    {
      "Name" = local.codedeploy_deployment_group_name
    }
  )
}
