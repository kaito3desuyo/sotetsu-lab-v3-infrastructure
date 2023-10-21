resource "aws_cloudfront_distribution" "for_web" {
  enabled             = true
  default_root_object = "index.html"
  is_ipv6_enabled     = true
  http_version        = "http2"
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = true
  aliases             = ["v3.sotetsu-lab.com"]

  viewer_certificate {
    acm_certificate_arn            = var.acm_arn
    minimum_protocol_version       = "TLSv1.2_2019"
    ssl_support_method             = "sni-only"
    cloudfront_default_certificate = false
  }

  origin {
    domain_name              = aws_s3_bucket.for_web.bucket_regional_domain_name
    origin_id                = "S3-${aws_s3_bucket.for_web.id}"
    origin_access_control_id = aws_cloudfront_origin_access_control.for_web.id
  }

  origin {
    domain_name = var.bff_domain_name
    origin_id   = "Backend For Frontend"
    origin_path = "/prod"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols = [
        "TLSv1.2",
      ]
    }
  }

  ordered_cache_behavior {
    path_pattern           = "/api/*"
    allowed_methods        = ["GET", "PUT", "POST", "DELETE", "PATCH", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    target_origin_id       = "Backend For Frontend"
    viewer_protocol_policy = "redirect-to-https"
    cache_policy_id        = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    target_origin_id       = "S3-${aws_s3_bucket.for_web.id}"
    viewer_protocol_policy = "redirect-to-https"
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"

    function_association {
      event_type   = "viewer-request"
      function_arn = "arn:aws:cloudfront::442730633672:function/spa-routing"
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

resource "aws_cloudfront_origin_access_control" "for_web" {
  name                              = "sotetsu-lab-v3-web-cf-oac"
  description                       = "Sotetsu Lab v3 Web CloudFront Origin Access Control"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
