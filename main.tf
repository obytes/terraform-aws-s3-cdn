module "webapp" {
  source      = "./modules/route53"
  prefix      = var.prefix
  common_tags = var.common_tags

  enable  = var.enable
  comment = var.comment

  dns_zone_id = var.dns_zone_id
  main_fqdn   = var.main_fqdn
  media_fqdn  = var.media_fqdn

  media_signer_public_key = var.media_signer_public_key
  content_security_policy = var.content_security_policy

  # Artifacts
  s3_artifacts = var.s3_artifacts

  # Github
  github            = var.github
  pre_release       = var.prefix
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
