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
      value = aws_s3_bucket.for_web.name
    }

    environment_variable {
      name  = "CLOUDFRONT_DISTRIBUTION_ID"
      value = aws_cloudfront_distribution.for_web.id
    }
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE", "LOCAL_CUSTOM_CACHE"]
  }
}
