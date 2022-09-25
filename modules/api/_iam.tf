################################################################################
# 共通IAMポリシー
################################################################################
resource "aws_iam_policy" "ssm_get_parameters_role_policy" {
  name   = "${var.name}-ssm-get-parameters-role-policy"
  policy = templatefile("${path.module}/assets/ssm_get_parameters_role_policy.tpl.json", {})
}


################################################################################
# CodePipelineIAMロール
################################################################################
data "aws_iam_policy_document" "api_codepipeline_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "api_codepipeline_role" {
  name               = "${var.name}-api-codepipeline-role"
  assume_role_policy = data.aws_iam_policy_document.api_codepipeline_assume_role_policy.json
}

resource "aws_iam_policy" "api_codepipeline_role_policy" {
  name = "${var.name}-api-codepipeline-role-policy"

  policy = templatefile("${path.module}/assets/codepipeline_role_policy.tpl.json", {
    codestar_connection_arn          = aws_codestarconnections_connection.for_api.arn
    codepipeline_artifact_bucket_arn = aws_s3_bucket.for_api_codepipeline_artifact.arn
    codebuild_project_arn            = aws_codebuild_project.for_api.arn
  })
}

resource "aws_iam_role_policy_attachment" "api_codepipeline_role_attachment01" {
  role       = aws_iam_role.api_codepipeline_role.name
  policy_arn = aws_iam_policy.api_codepipeline_role_policy.arn
}


################################################################################
# CodeBuildIAMロール
################################################################################
data "aws_iam_policy_document" "api_codebuild_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "api_codebuild_role" {
  name               = "${var.name}-api-codebuild-role"
  assume_role_policy = data.aws_iam_policy_document.api_codebuild_assume_role_policy.json
}

resource "aws_iam_policy" "api_codebuild_role_policy" {
  name = "${var.name}-api-codebuild-role-policy"

  policy = templatefile("${path.module}/assets/codebuild_role_policy.tpl.json", {
    codestar_connection_arn          = aws_codestarconnections_connection.for_api.arn
    codepipeline_artifact_bucket_arn = aws_s3_bucket.for_api_codepipeline_artifact.arn
    ecr_repository_arn               = aws_ecr_repository.for_api.arn
    cloudwacth_logs_arn              = aws_cloudwatch_log_group.for_api_codebuild.arn
  })
}

resource "aws_iam_role_policy_attachment" "api_codebuild_role_attachment01" {
  role       = aws_iam_role.api_codebuild_role.name
  policy_arn = aws_iam_policy.api_codebuild_role_policy.arn
}


################################################################################
# CodeDeployIAMロール
################################################################################
data "aws_iam_policy_document" "api_codedeploy_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "api_codedeploy_role" {
  name               = "${var.name}-codedeploy-role"
  assume_role_policy = data.aws_iam_policy_document.api_codedeploy_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "api_codedeploy_role_attachment01" {
  role       = aws_iam_role.api_codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}
