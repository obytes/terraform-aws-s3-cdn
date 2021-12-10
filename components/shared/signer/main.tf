locals {
  prefix      = "${var.prefix}-cdn-signer"
  common_tags = merge(var.common_tags, {
      "modules" = "cdn-signer"
  })
}
