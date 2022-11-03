resource "github_actions_secret" "deploy_bucket_name" {
  repository      = var.github_repository_name
  secret_name     = "DEPLOY_BUCKET_NAME"
  plaintext_value = aws_s3_bucket.for_web.bucket
}

resource "github_actions_secret" "cloudfront_distribution_id" {
  repository      = var.github_repository_name
  secret_name     = "CLOUDFRONT_DISTRIBUTION_ID"
  plaintext_value = aws_cloudfront_distribution.for_web.id
}
