resource "aws_cloudwatch_log_group" "for_api_codebuild" {
  name = "/aws/codebuild/${var.name}-api"
}
