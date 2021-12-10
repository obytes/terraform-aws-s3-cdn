###############################################
#                  WEB APP S3                 |
#             The cloudfront origin           |
###############################################

resource "aws_s3_bucket" "_" {
  bucket = var.fqdn
  acl    = "public-read"

  website {
    index_document = local.index_document
    error_document = local.error_document
  }

  force_destroy = true
  tags          = merge(
    local.common_tags,
    {usage = "Host web application static content delivered by s3"}
  )
}
