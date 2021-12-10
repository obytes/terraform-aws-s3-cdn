resource "aws_s3_bucket_object" "index_document" {
  count        = var.is_preview ? 1:0
  key          = local.index_document
  acl          = "public-read"
  bucket       = aws_s3_bucket._.id
  content      = "Welcome to the preview CDN, use https://[pull_request_number]-${var.fqdn} to access a PR preview."
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "error_document" {
  count        = var.is_preview ? 1:0
  key          = local.error_document
  acl          = "public-read"
  bucket       = aws_s3_bucket._.id
  content      = "Found no preview for this pull request!"
  content_type = "text/html"
}
