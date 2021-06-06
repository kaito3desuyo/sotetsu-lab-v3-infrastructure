resource "aws_s3_bucket" "for_api_codepipeline_artifact" {
  bucket = "${var.name}-api-codepipeline-artifact"
  acl    = "private"

  tags = {
    Name = "${var.name}-api-codepipeline-artifact"
  }
}

resource "aws_s3_bucket_public_access_block" "for_api_codepipeline_artifact" {
  bucket = aws_s3_bucket.for_api_codepipeline_artifact.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
