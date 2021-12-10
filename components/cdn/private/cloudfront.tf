###############################################
#                ACCESS IDENTITY              |
#   Restricting Access to Amazon S3 Content   |
###############################################
resource "aws_cloudfront_origin_access_identity" "_" {
  comment = local.prefix
}

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
  comment             = var.comment
  default_root_object = var.default_root_object
  price_class         = var.price_class
  aliases             = length(var.domain_aliases) > 0 ? var.domain_aliases : [var.fqdn]

  #########################
  # S3 Origin configuration
  #########################
  origin {
    domain_name = "${aws_s3_bucket._.id}.s3.amazonaws.com"
    origin_id   = local.media_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity._.cloudfront_access_identity_path
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
    target_origin_id = local.media_origin_id
    allowed_methods  = [ "GET", "HEAD", "OPTIONS", ]
    cached_methods   = [ "GET", "HEAD", "OPTIONS", ]

    compress                   = true
    cache_policy_id            = var.cache_policy_id
    origin_request_policy_id   = var.origin_request_policy_id
    response_headers_policy_id = var.response_headers_policy_id
    viewer_protocol_policy     = "redirect-to-https"
    trusted_key_groups         = length(var.trusted_key_groups) > 0 ? var.trusted_key_groups : null
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
