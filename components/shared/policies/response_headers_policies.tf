resource "aws_cloudfront_response_headers_policy" "_" {
  name = "${local.prefix}-security-headers"

  cors_config {
    origin_override                  = true
    access_control_max_age_sec       = 86400
    access_control_allow_credentials = false

    access_control_allow_origins {
      items = ["*"]
    }

    access_control_allow_headers {
      items = ["*"]
    }

    access_control_allow_methods {
      items = ["GET", "HEAD", "OPTIONS"]
    }
  }

  security_headers_config {
    strict_transport_security {
      override                   = true
      preload                    = true
      include_subdomains         = true
      access_control_max_age_sec = "31536000"
    }
    content_security_policy {
      override                = true
      content_security_policy = var.content_security_policy
    }
    frame_options {
      override     = true
      frame_option = "SAMEORIGIN"
    }
    content_type_options {
      override = true
    }
    referrer_policy {
      override        = true
      referrer_policy = "strict-origin-when-cross-origin"
    }
    xss_protection {
      override   = true
      mode_block = true
      protection = true
    }
  }
}
