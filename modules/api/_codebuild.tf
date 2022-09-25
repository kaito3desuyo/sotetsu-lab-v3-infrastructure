resource "aws_codebuild_project" "for_api" {
  name         = "${var.name}-api"
  service_role = aws_iam_role.api_codebuild_role.arn

  source {
    type = "CODEPIPELINE"
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:6.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "DOCKER_HUB_USERNAME"
      value = "docker-hub-username"
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name  = "DOCKER_HUB_PASSWORD"
      value = "docker-hub-password"
      type  = "PARAMETER_STORE"
    }

    environment_variable {
      name  = "DOCKER_BUILDKIT"
      value = 1
    }

    environment_variable {
      name  = "IMAGE_NAME"
      value = aws_ecr_repository.for_api.name
    }
  }

  cache {
    type = "LOCAL"
    modes = [
      "LOCAL_SOURCE_CACHE",
      "LOCAL_DOCKER_LAYER_CACHE",
      "LOCAL_CUSTOM_CACHE"
    ]
  }

  logs_config {
    cloudwatch_logs {
      status     = "ENABLED"
      group_name = aws_cloudwatch_log_group.for_api_codebuild.name
    }
    s3_logs {
      status = "DISABLED"
    }
  }
}
