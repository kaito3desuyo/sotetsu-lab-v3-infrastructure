resource "aws_codestarconnections_connection" "for_web" {
  name          = "${var.name}-web-csc"
  provider_type = "GitHub"
}
