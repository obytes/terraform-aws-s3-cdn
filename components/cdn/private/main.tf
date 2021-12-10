locals {
  prefix      = "${var.prefix}-media"
  common_tags = merge(var.common_tags, {
    modules = "public-cdn"
  })

  media_origin_id = "s3-${aws_s3_bucket._.id}"
}
