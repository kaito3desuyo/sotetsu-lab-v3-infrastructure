resource "aws_ecr_repository" "for_api" {
  name                 = "seapolis/${var.name}-api"
  image_tag_mutability = "IMMUTABLE"
}
