resource "aws_s3_bucket" "for_web" {
  bucket = "${var.name}-client-prod"

  tags = {
    "Name" = "${var.name}-client-prod"
  }
}

resource "aws_s3_bucket_public_access_block" "for_web" {
  bucket                  = aws_s3_bucket.for_web.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "for_web" {
  bucket = aws_s3_bucket.for_web.bucket
  acl    = "private"
}

resource "aws_s3_bucket_policy" "for_web" {
  bucket = aws_s3_bucket.for_web.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.for_web.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [aws_cloudfront_distribution.for_web.arn]
    }
  }
}
