locals {
  prefix      = "${var.prefix}-webapp"
  common_tags = merge(var.common_tags, {
    usage = "serverless-webapp-cdn-n-ci"
  })

  preview_fqdn_base     = "preview.${var.main_fqdn}"
  preview_fqdn_wildcard = "*.${var.main_fqdn}"
}
