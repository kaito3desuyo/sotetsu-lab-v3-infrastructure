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
    image                       = "aws/codebuild/standard:2.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true

    environment_variable {
      name  = "REPOSITORY_URI"
      value = aws_ecr_repository.for_api.repository_url
    }
  }

  cache {
    type  = "NO_CACHE"
    modes = []
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
