################################
# Shared CDN Settings
################################

module "webapp_policies" {
  source      = "../../components/shared/policies"
  prefix      = local.prefix
  common_tags = local.common_tags

  content_security_policy = var.content_security_policy
}

module "url_rewrite_function" {
  source      = "../../components/shared/url-rewrite-function"
  prefix      = local.prefix
  common_tags = local.common_tags
}

module "webapp_private_media_signer" {
  source      = "../../components/shared/signer"
  prefix      = local.prefix
  common_tags = local.common_tags
  public_key  = var.media_signer_public_key
}

###########################
# Web Application Main CDN
###########################

module "webapp_main_cdn" {
  count       = var.enable.main ? 1:0
  source      = "../../components/cdn/public"
  common_tags = local.common_tags

  # DNS
  fqdn           = var.main_fqdn
  cert_arn       = var.acm_cert_arn

  # Cloudfront
  comment                    = "Main | ${var.comment}"
  cache_policy_id            = module.webapp_policies.cache_policy_id
  origin_request_policy_id   = module.webapp_policies.origin_request_policy_id
  response_headers_policy_id = module.webapp_policies.response_headers_policy_id

  url_rewrite_function_arn = module.url_rewrite_function.arn
}

module "webapp_main_ci" {
  count       = var.enable.main ? 1:0
  source      = "git::https://github.com/obytes/terraform-aws-s3-ci.git//modules/webapp-release"
  prefix      = local.prefix
  common_tags = local.common_tags

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

  # Web & Cloudfront
  s3_web                     = module.webapp_main_cdn[0].s3
  cloudfront_distribution_id = module.webapp_main_cdn[0].dist["id"]

  # Notification
  ci_notifications_slack_channels = var.ci_notifications_slack_channels
}

#############################
# Web Application Preview CDN
#############################

module "webapp_pr_preview_cdn" {
  count       = var.enable.preview ? 1:0
  source      = "../../components/cdn/public"
  common_tags = local.common_tags

  # DNS
  fqdn           = local.preview_fqdn_base
  cert_arn       = var.acm_cert_arn
  domain_aliases = [ local.preview_fqdn_base, local.preview_fqdn_wildcard ]

  # Cloudfront
  comment                    = "Preview | ${var.comment}"
  cache_policy_id            = module.webapp_policies.cache_policy_id
  origin_request_policy_id   = module.webapp_policies.origin_request_policy_id
  response_headers_policy_id = module.webapp_policies.response_headers_policy_id

  is_preview               = true
  url_rewrite_function_arn = module.url_rewrite_function.arn
}

module "webapp_pr_preview_ci" {
  count       = var.enable.preview ? 1:0
  source      = "git::https://github.com/obytes/terraform-aws-s3-ci.git//modules/webapp-preview"
  prefix      = local.prefix
  common_tags = local.common_tags

  # Artifacts
  s3_artifacts = var.s3_artifacts

  # Github
  github            = var.github
  repository_name   = var.github_repository.name

  # Build
  app_base_dir          = var.app_base_dir
  app_build_dir         = var.app_build_dir
  app_node_version      = var.app_node_version
  app_install_cmd       = var.app_install_cmd
  app_build_cmd         = var.app_build_cmd
  app_preview_base_fqdn = local.preview_fqdn_base

  # Web & Cloudfront
  s3_web                     = module.webapp_pr_preview_cdn[0].s3
  cloudfront_distribution_id = module.webapp_pr_preview_cdn[0].dist["id"]
}

###################################
# Web Application Private Media CDN
###################################

module "webapp_media_cdn" {
  count       = var.enable.private_media && length(var.media_signer_public_key) > 0 ? 1:0
  source      = "../../components/cdn/private"
  prefix      = "${local.prefix}-private-media"
  common_tags = local.common_tags

  # DNS
  fqdn     = var.private_media_fqdn
  cert_arn = var.acm_cert_arn

  # Cloudfront
  comment                    = "Private Media | ${var.comment}"
  cache_policy_id            = module.webapp_policies.cache_policy_id
  origin_request_policy_id   = module.webapp_policies.origin_request_policy_id
  response_headers_policy_id = module.webapp_policies.response_headers_policy_id
  trusted_key_groups         = [module.webapp_private_media_signer.cloudfront_key_group_id]
}

###################################
# Web Application Public Media CDN
###################################

module "webapp_public_media_cdn" {
  count       = var.enable.public_media ? 1:0
  source      = "../../components/cdn/private"
  prefix      = "${local.prefix}-public-media"
  common_tags = local.common_tags

  # DNS
  fqdn     = var.public_media_fqdn
  cert_arn = var.acm_cert_arn

  # Cloudfront
  comment                    = "Public Media | ${var.comment}"
  cache_policy_id            = module.webapp_policies.cache_policy_id
  origin_request_policy_id   = module.webapp_policies.origin_request_policy_id
  response_headers_policy_id = module.webapp_policies.response_headers_policy_id
}
