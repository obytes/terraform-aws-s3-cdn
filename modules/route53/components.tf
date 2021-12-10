################################
# Certification
################################

module "certification" {
  source  = "git::https://github.com/obytes/terraform-aws-certify//modules/route53"

  r53_zone_id              = var.dns_zone_id
  domain_name              = var.main_fqdn
  alternative_domain_names = [local.preview_fqdn_wildcard, var.media_fqdn]
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

  acm_cert_arn = module.certification.cert_arn
  main_fqdn    = var.main_fqdn
  media_fqdn   = var.media_fqdn

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
resource "aws_route53_record" "main_dns_record" {
  count   = length(module.webapp["main_cdn_dist"])
  zone_id = var.dns_zone_id
  name    = var.main_fqdn
  type    = "A"

  alias {
    name                   = module.webapp.main_cdn_dist[count.index]["domain_name"]
    zone_id                = module.webapp.main_cdn_dist[count.index]["zone_id"]
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "preview_dns_record" {
  count   = length(module.webapp["preview_cdn_dist"])
  zone_id = var.dns_zone_id
  name    = local.preview_fqdn_wildcard
  type    = "A"

  alias {
    name                   = module.webapp.preview_cdn_dist[count.index]["domain_name"]
    zone_id                = module.webapp.preview_cdn_dist[count.index]["zone_id"]
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "media_dns_record" {
  count   = length(module.webapp["media_cdn_dist"])
  zone_id = var.dns_zone_id
  name    = var.media_fqdn
  type    = "A"

  alias {
    name                   = module.webapp.media_cdn_dist[count.index]["domain_name"]
    zone_id                = module.webapp.media_cdn_dist[count.index]["zone_id"]
    evaluate_target_health = true
  }
}
