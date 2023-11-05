# resource "github_actions_secret" "ecs_taskdef_family" {
#   repository      = var.github_repository_name
#   secret_name     = "AWS_ECS_TASKDEF_FAMILY"
#   plaintext_value = aws_ecs_task_definition.for_api.family
# }

# resource "github_actions_secret" "ecs_cluster_name" {
#   repository      = var.github_repository_name
#   secret_name     = "AWS_ECS_CLUSTER_NAME"
#   plaintext_value = aws_ecs_cluster.for_api.name
# }

# resource "github_actions_secret" "ecs_service_name" {
#   repository      = var.github_repository_name
#   secret_name     = "AWS_ECS_SERVICE_NAME"
#   plaintext_value = aws_ecs_service.for_api.name
# }

# resource "github_actions_secret" "ecr_repository_name" {
#   repository      = var.github_repository_name
#   secret_name     = "AWS_ECR_REPOSITORY_NAME"
#   plaintext_value = aws_ecr_repository.for_api.name
# }

# resource "github_actions_secret" "ecs_task_role_arn" {
#   repository      = var.github_repository_name
#   secret_name     = "AWS_ECS_TASK_ROLE_ARN"
#   plaintext_value = aws_iam_role.ecs_task_role.arn
# }

# resource "github_actions_secret" "ecs_task_execution_role_arn" {
#   repository      = var.github_repository_name
#   secret_name     = "AWS_ECS_TASK_EXECUTION_ROLE_ARN"
#   plaintext_value = aws_iam_role.ecs_task_execution_role.arn
# }

# resource "github_actions_secret" "cloudwatch_log_group_name" {
#   repository      = var.github_repository_name
#   secret_name     = "AWS_CLOUDWATCH_LOG_GROUP_NAME"
#   plaintext_value = aws_cloudwatch_log_group.for_ecs.name
# }

# resource "github_actions_secret" "cloudwatch_log_stream_prefix" {
#   repository      = var.github_repository_name
#   secret_name     = "AWS_CLOUDWATCH_LOG_STREAM_PREFIX"
#   plaintext_value = local.cloudwatch_log_stream_prefix
# }

# resource "github_actions_secret" "codedeploy_application_name" {
#   repository      = var.github_repository_name
#   secret_name     = "AWS_CODEDEPLOY_APPLICATION_NAME"
#   plaintext_value = aws_codedeploy_app.for_api.name
# }

# resource "github_actions_secret" "codedeploy_deployment_group_name" {
#   repository      = var.github_repository_name
#   secret_name     = "AWS_CODEDEPLOY_DEPLOYMENT_GROUP_NAME"
#   plaintext_value = aws_codedeploy_deployment_group.for_api.deployment_group_name
# }
