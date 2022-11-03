resource "aws_s3_bucket" "for_api_codepipeline_artifact" {
  bucket = local.codepipeline_artifact_bucket_name

  tags = {
    "Name" = local.codepipeline_artifact_bucket_name
  }
}

resource "aws_s3_bucket_acl" "for_api_codepipeline_artifact" {
  bucket = aws_s3_bucket.for_api_codepipeline_artifact.bucket
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "for_api_codepipeline_artifact" {
  bucket                  = aws_s3_bucket.for_api_codepipeline_artifact.bucket
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
