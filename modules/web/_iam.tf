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

data "aws_iam_policy_document" "web_codebuild_role_policy" {
  statement {
    actions = ["s3:GetObject", "s3:PutObject", "s3:PutObjectAcl"]
    resources = [
      "*"
    ]
  }

  statement {
    actions = ["s3:ListBucket", "s3:PutObject", "s3:DeleteObject"]
    resources = [
      "*"
    ]
  }

  statement {
    actions = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = [
      "*"
    ]
  }

  statement {
    actions = ["cloudfront:CreateInvalidation"]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role" "web_codebuild_role" {
  name               = "${var.name}-web-codebuild-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role_policy.json
}

resource "aws_iam_policy" "web_codebuild_role_policy" {
  name   = "${var.name}-web-codebuild-role-policy"
  policy = data.aws_iam_policy_document.web_codebuild_role_policy.json
}

resource "aws_iam_role_policy_attachment" "web_codebuild_role_policy_attachment01" {
  role       = aws_iam_role.web_codebuild_role.name
  policy_arn = aws_iam_policy.web_codebuild_role_policy.arn
}
