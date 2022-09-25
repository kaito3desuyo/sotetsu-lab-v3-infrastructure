resource "aws_codestarconnections_connection" "for_api" {
  name          = "${var.name}-api"
  provider_type = "GitHub"
}
