################################################################################
# CodePipeline IAM Role
################################################################################
data "aws_iam_policy_document" "codepipeline_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "web_codepipeline_role" {
  name               = "${var.name}-web-codepipeline-role"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume_role_policy.json
}

resource "aws_iam_policy" "web_codepipeline_role_policy" {
  name = "${var.name}-web-codepipeline-role-policy"

  policy = templatefile("${path.module}/assets/codepipeline_role_policy.tpl.json", {
    codestar_connection_arn          = aws_codestarconnections_connection.for_web.arn
    codepipeline_artifact_bucket_arn = aws_s3_bucket.for_codepipeline_artifact.arn
    codebuild_project_arn            = aws_codebuild_project.for_web.arn
  })
}

resource "aws_iam_role_policy_attachment" "web_codepipeline_role_attachment01" {
  role       = aws_iam_role.web_codepipeline_role.name
  policy_arn = aws_iam_policy.web_codepipeline_role_policy.arn
}


################################################################################
# CodeBuild IAM Role
################################################################################
data "aws_iam_policy_document" "codebuild_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "web_codebuild_role" {
  name               = "${var.name}-web-codebuild-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role_policy.json
}

resource "aws_iam_policy" "web_codebuild_role_policy" {
  name = "${var.name}-web-codebuild-role-policy"
  policy = templatefile("${path.module}/assets/codebuild_role_policy.tpl.json", {
    codepipeline_artifact_bucket_arn = aws_s3_bucket.for_codepipeline_artifact.arn
    destination_bucket_arn           = aws_s3_bucket.for_web.arn
    cloudwacth_logs_arn              = aws_cloudwatch_log_group.for_web_codebuild.arn
    cloudfront_distribution_arn      = aws_cloudfront_distribution.for_web.arn
  })
}

resource "aws_iam_role_policy_attachment" "web_codebuild_role_policy_attachment01" {
  role       = aws_iam_role.web_codebuild_role.name
  policy_arn = aws_iam_policy.web_codebuild_role_policy.arn
}
