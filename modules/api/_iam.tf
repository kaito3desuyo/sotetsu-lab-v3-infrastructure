# ECS タスクロール
data "aws_iam_policy_document" "ecs_task_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs_task_role_policy" {
  statement {
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role" "ecs_task_role" {
  name               = local.ecs_task_role_name
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role_policy.json
}

resource "aws_iam_policy" "ecs_task_role_policy" {
  name   = local.ecs_task_role_policy_name
  policy = data.aws_iam_policy_document.ecs_task_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_policy_attachment_01" {
  role       = aws_iam_role.ecs_task_role.id
  policy_arn = aws_iam_policy.ecs_task_role_policy.arn
}

# ECS タスク実行ロール
data "aws_iam_policy_document" "ecs_task_execution_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs_task_execution_role_policy" {
  statement {
    actions = [
      "ssm:GetParameters",
      "secretsmanager:GetSecretValue",
      "kms:Decrypt",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = local.ecs_task_execution_role_name
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_assume_role_policy.json
}

resource "aws_iam_policy" "ecs_task_execution_role_policy" {
  name   = local.ecs_task_execution_role_policy_name
  policy = data.aws_iam_policy_document.ecs_task_execution_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment_01" {
  role       = aws_iam_role.ecs_task_execution_role.id
  policy_arn = aws_iam_policy.ecs_task_execution_role_policy.arn
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment_02" {
  role       = aws_iam_role.ecs_task_execution_role.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# CodeDeploy ロール
data "aws_iam_policy_document" "codedeploy_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codedeploy_role" {
  name               = local.codedeploy_role_name
  assume_role_policy = data.aws_iam_policy_document.codedeploy_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "codedeploy_role_attachment_01" {
  role       = aws_iam_role.codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}
