################################
# Certification
################################

module "certification" {
  source  = "git::https://github.com/obytes/terraform-aws-certify.git//modules/cloudflare"

  cloudflare_zone_id       = var.dns_zone_id
  domain_name              = var.main_fqdn
  alternative_domain_names = compact([local.preview_fqdn_wildcard, var.private_media_fqdn, var.public_media_fqdn])
}

####################
# Webapp CDN and CI
####################

module "webapp" {
  source      = "../../modules/webapp"
  prefix      = var.prefix
  common_tags = local.common_tags

  enable  = var.enable
  comment = var.comment

  acm_cert_arn       = module.certification.cert_arn
  main_fqdn          = var.main_fqdn
  private_media_fqdn = var.private_media_fqdn
  public_media_fqdn  = var.public_media_fqdn

  media_signer_public_key = var.media_signer_public_key
  content_security_policy = var.content_security_policy

  # Artifacts
  s3_artifacts = var.s3_artifacts

  # Github
  github            = var.github
  pre_release       = var.pre_release
  github_repository = var.github_repository

  # Build
  app_base_dir          = var.app_base_dir
  app_build_dir         = var.app_build_dir
  app_node_version      = var.app_node_version
  app_install_cmd       = var.app_install_cmd
  app_build_cmd         = var.app_build_cmd

  # Notification
  ci_notifications_slack_channels = var.ci_notifications_slack_channels
}


#####################
# Route53 DNS records
#####################
resource "cloudflare_record" "main_dns_record" {
  count   = length(module.webapp.main_cdn_dist)
  zone_id = var.dns_zone_id
  name    = var.main_fqdn
  type    = "A"
  value   = module.webapp.main_cdn_dist[count.index]["domain_name"]
  proxied = false
}

resource "cloudflare_record" "preview_dns_record" {
  count   = length(module.webapp.preview_cdn_dist)
  zone_id = var.dns_zone_id
  name    = local.preview_fqdn_wildcard
  type    = "A"
  value   = module.webapp.preview_cdn_dist[count.index]["domain_name"]
  proxied = false
}

resource "cloudflare_record" "private_media_dns_record" {
  count   = length(module.webapp.private_media_cdn_dist)
  zone_id = var.dns_zone_id
  name    = var.private_media_fqdn
  type    = "A"
  value   = module.webapp.private_media_cdn_dist[count.index]["domain_name"]
  proxied = false
}

resource "cloudflare_record" "public_media_dns_record" {
  count   = length(module.webapp.public_media_cdn_dist)
  zone_id = var.dns_zone_id
  name    = var.public_media_fqdn
  type    = "A"
  value   = module.webapp.public_media_cdn_dist[count.index]["domain_name"]
  proxied = false
}
