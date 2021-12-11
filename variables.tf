# General
# --------
variable "prefix" {
  description = "Used for prefixing resources"
}

variable "common_tags" {
  type        = map(string)
  description = "Resources common tags"
}

variable "comment" {
  default     = "Web application CDN"
  description = "A small description of the s3 static cdn purpose"
}

variable "enable" {
  type = object({
    main    = bool
    preview = bool
    media   = bool
  })
}

variable "media_signer_public_key" {
  default = [ ]
}

variable "content_security_policy" {
  default = "default-src * 'unsafe-inline'"
}

# DNS
# ---
variable "dns_zone_id" {
  description = "Route53 Zone ID"
}

variable "main_fqdn" {
  description = "Main CDN fqdn"
}

variable "media_fqdn" {
  description = "Media CDN fqdn"
}

# Github
# --------
variable "github" {
  type        = object({
    owner          = string
    token          = string
    connection_arn = string
    webhook_secret = string
  })
}

variable "pre_release" {
  default = true
}

variable "github_repository" {
  type = object({
    name   = string
    branch = string
  })
}

# Artifacts
# ----------
variable "s3_artifacts" {
  type = object({
    bucket = string
    arn    = string
  })
}

# Notification
# ------------
variable "ci_notifications_slack_channels" {
  description = "Slack channel name for notifying ci pipeline info/alerts"
  type        = object({
    info  = string
    alert = string
  })
}


# Build
# -----
variable "app_base_dir" {
  default = "."
}
variable "app_node_version" {}
variable "app_install_cmd" {}
variable "app_build_cmd" {}
variable "app_build_dir" {}
