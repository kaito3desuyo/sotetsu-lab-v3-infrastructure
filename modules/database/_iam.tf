locals {
  rds_proxy_role_name        = "${local.prefix}-rds-proxy-role"
  rds_proxy_role_policy_name = "${local.prefix}-rds-proxy-role-policy"
}

data "aws_iam_policy_document" "rds_proxy_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "rds_proxy_role_policy" {
  statement {
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [
      aws_secretsmanager_secret.main.arn
    ]
  }
}

resource "aws_iam_role" "rds_proxy_role" {
  name               = local.rds_proxy_role_name
  assume_role_policy = data.aws_iam_policy_document.rds_proxy_assume_role_policy.json

  tags = merge(
    local.module_tags,
    {
      "Name" = local.rds_proxy_role_name
    }
  )
}

resource "aws_iam_policy" "rds_proxy_role_policy" {
  name   = local.rds_proxy_role_policy_name
  policy = data.aws_iam_policy_document.rds_proxy_role_policy.json

  tags = merge(
    local.module_tags,
    {
      "Name" = local.rds_proxy_role_policy_name
    }
  )
}

resource "aws_iam_role_policy_attachment" "rds_proxy_role_policy_attachment_01" {
  role       = aws_iam_role.rds_proxy_role.name
  policy_arn = aws_iam_policy.rds_proxy_role_policy.arn
}
