locals {
  prefix      = "${var.prefix}-cdn-policies"
  common_tags = merge(var.common_tags, {
    modules = "cdn-shared-policies"
  })
}
