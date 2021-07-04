resource "aws_cloudwatch_log_group" "for_web_codebuild" {
  name = "/aws/codebuild/${var.name}-prod-web-codebuild"
}
