resource "aws_codepipeline" "for_api" {
  name     = "${var.name}-api"
  role_arn = aws_iam_role.api_codepipeline_role.arn

  artifact_store {
    type     = "S3"
    location = aws_s3_bucket.for_api_codepipeline_artifact.id
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      run_order        = 1
      output_artifacts = ["SourceArtifact"]
      configuration = {
        "OutputArtifactFormat" = "CODEBUILD_CLONE_REF"
        "ConnectionArn"        = aws_codestarconnections_connection.for_api.arn
        "FullRepositoryId"     = var.github_repository_name
        "BranchName"           = "master"
      }
    }
  }

  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      run_order        = 1
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["DefinitionArtifact", "ImageArtifact"]
      configuration = {
        "ProjectName" = aws_codebuild_project.for_api.name
      }
    }
  }

  stage {
    name = "Deploy"
    action {
      name            = "deploy-to-ecs"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeployToECS"
      version         = "1"
      run_order       = 1
      input_artifacts = ["DefinitionArtifact", "ImageArtifact"]
      configuration = {
        "ApplicationName"                = aws_codedeploy_app.for_api.name
        "DeploymentGroupName"            = aws_codedeploy_deployment_group.for_api.deployment_group_name
        "TaskDefinitionTemplateArtifact" = "DefinitionArtifact"
        "AppSpecTemplateArtifact"        = "DefinitionArtifact"
        "Image1ArtifactName"             = "ImageArtifact"
        "Image1ContainerName"            = "IMAGE1_NAME"
      }
    }
  }
}
