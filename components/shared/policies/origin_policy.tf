resource "aws_cloudfront_origin_request_policy" "_" {
  name    = "${local.prefix}-origin-policy"
  comment = "Policy for S3 origin with CORS"

  cookies_config {
    cookie_behavior = "none"
  }

  query_strings_config {
    query_string_behavior = "all"
  }

  headers_config {
    header_behavior = "whitelist"
    headers {
      items = [
        "x-forwarded-host",
        "origin",
        "access-control-request-headers",
        "x-forwarded-for",
        "access-control-request-method",
        "user-agent",
        "referer"
      ]
    }
  }
}
