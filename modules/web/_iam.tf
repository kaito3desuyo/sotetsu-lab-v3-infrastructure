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
