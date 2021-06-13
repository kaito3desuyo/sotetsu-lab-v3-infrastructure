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
