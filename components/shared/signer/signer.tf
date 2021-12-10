resource "aws_cloudfront_public_key" "_" {
  name        = local.prefix
  encoded_key = var.public_key
}

resource "aws_cloudfront_key_group" "_" {
  name  = local.prefix
  items = [aws_cloudfront_public_key._.id]
}
