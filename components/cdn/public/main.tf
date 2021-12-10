locals {
  common_tags   = merge(var.common_tags, {
    modules = "public-cdn"
  })
  web_origin_id = "s3-${aws_s3_bucket._.id}"

  index_document = var.is_preview ? "index.html": var.index_document
  error_document = var.is_preview ? "error.html": var.error_document
}
