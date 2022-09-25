resource "aws_codepipeline" "for_web" {
  name     = "${var.name}-client_prod"
  role_arn = aws_iam_role.web_codepipeline_role.arn

  artifact_store {
    type     = "S3"
    location = aws_s3_bucket.for_codepipeline_artifact.id
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
        "ConnectionArn"        = aws_codestarconnections_connection.for_web.arn
        "FullRepositoryId"     = var.github_repository_name
        "BranchName"           = "master"
      }
    }
  }

  stage {
    name = "Build"
    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      run_order       = 1
      input_artifacts = ["SourceArtifact"]
      configuration = {
        "ProjectName" = aws_codebuild_project.for_web.name
      }
    }
  }
}
