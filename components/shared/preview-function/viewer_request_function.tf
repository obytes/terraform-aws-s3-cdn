resource "aws_cloudfront_function" "viewer_request" {
  name    = "${local.prefix}-viewer-req"
  code    = file("${path.module}/viewer_request_function.js")
  comment = "Viewer Request Function"
  runtime = "cloudfront-js-1.0"
  publish = true
}
