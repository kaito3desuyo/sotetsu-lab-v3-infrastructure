resource "aws_s3_bucket" "for_web" {
  bucket = "${var.name}-client-prod"
  acl    = "private"

  tags = {
    "Name" = "${var.name}-client-prod"
  }
}

resource "aws_s3_bucket_public_access_block" "for_web" {
  bucket = aws_s3_bucket.for_web.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

################################################################################
# CodePipeline Artifact Bucket
################################################################################
resource "aws_s3_bucket" "for_codepipeline_artifact" {
  bucket = "${var.name}-web-codepipeline-artifact"
  acl    = "private"

  tags = {
    Name = "${var.name}-web-codepipeline-artifact"
  }
}

resource "aws_s3_bucket_public_access_block" "for_codepipeline_artifact" {
  bucket = aws_s3_bucket.for_codepipeline_artifact.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
