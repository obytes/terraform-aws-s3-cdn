###############################################
#                ACCESS IDENTITY              |
#   Restricting Access to Amazon S3 Content   |
###############################################
resource "aws_cloudfront_distribution" "_" {

  #######################
  # General
  #######################
  enabled             = true
  is_ipv6_enabled     = true
  wait_for_deployment = true
  http_version        = "http2"
  comment             = var.comment
  default_root_object = local.index_document
  price_class         = var.price_class
  aliases             = length(var.domain_aliases) > 0 ? var.domain_aliases : [var.fqdn]

  #######################
  # WEB Origin config
  #######################
  origin {
    domain_name = aws_s3_bucket._.website_endpoint
    origin_id   = local.web_origin_id

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"

      origin_ssl_protocols = [
        "TLSv1",
        "TLSv1.1",
        "TLSv1.2",
      ]
    }
  }

  #########################
  # Certificate configuration
  #########################
  viewer_certificate {
    acm_certificate_arn            = var.cert_arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
    cloudfront_default_certificate = false
  }

  #######################
  # Logging configuration
  #######################
  dynamic "logging_config" {
    for_each = var.s3_logging != null ? [1] : []
    content {
      bucket          = var.s3_logging.address
      prefix          = "cloudfront"
      include_cookies = false
    }
  }

  #######################
  # WEB Caching configuration
  #######################
  default_cache_behavior {
    target_origin_id = local.web_origin_id
    allowed_methods  = [ "GET", "HEAD", "OPTIONS", ]
    cached_methods   = [ "GET", "HEAD", "OPTIONS", ]

    compress                   = true
    cache_policy_id            = var.cache_policy_id
    origin_request_policy_id   = var.origin_request_policy_id
    response_headers_policy_id = var.response_headers_policy_id
    viewer_protocol_policy     = "redirect-to-https"

    dynamic "function_association" {
      for_each = var.is_preview ? [1] : []
      content {
        event_type   = "viewer-request"
        function_arn = var.preview_function_arn
      }
    }
  }

  #######################
  # Restrictions
  #######################
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = local.common_tags
}
