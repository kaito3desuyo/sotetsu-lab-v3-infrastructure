resource "aws_codebuild_project" "for_web" {
  name         = "${var.name}-client_prod"
  service_role = aws_iam_role.web_codebuild_role.arn

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = false

    environment_variable {
      name  = "DEPLOY_STAGE"
      value = "prod"
    }

    environment_variable {
      name  = "BUCKET_NAME"
      value = "sotetsu-lab-v3-client-prod"
    }

    environment_variable {
      name  = "CLOUDFRONT_DISTRIBUTION_ID"
      value = "E5C8TB9HLVQF9"
    }
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE", "LOCAL_CUSTOM_CACHE"]
  }
}
