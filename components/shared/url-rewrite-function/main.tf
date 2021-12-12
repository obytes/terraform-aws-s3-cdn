locals {
  prefix      = "${var.prefix}-cdn-prev"
  common_tags = merge(var.common_tags, {
    modules = "cdn-preview-functions"
  })
}
