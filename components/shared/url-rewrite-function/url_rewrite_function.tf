resource "aws_cloudfront_function" "url_rewrite_viewer_request" {
  name    = "${local.prefix}-url-rewrite"
  code    = file("${path.module}/url_rewrite_function.js")
  comment = "URL Rewrite for single page applications or statically generated websites"
  runtime = "cloudfront-js-1.0"
  publish = true
}
