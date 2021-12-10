######################
#     VARIABLES      |
######################

# General
# --------
variable "common_tags" {
  type        = map(string)
  description = "Resources common tags"
}

# DNS
# ---
variable "cert_arn" {
  description = "ACM certificate used with cloudfront SSL it should be in us-east-1"
}

variable "fqdn" {
  description = "The fully qualified domain name will be used as bucket name and as domain alias if no domain aliases is provided, eg: preview.app.obytes.com"
}

variable "domain_aliases" {
  type        = list(string)
  description = "A list of domain aliases that will act as cloudfront aliases, should be a wildcard domains in the form of eg. *-preview.app.obytes.com"
  default     = [ ]
}

# Cloudfront
# ----------
variable "comment" {
  default     = "Web APP CDN"
  description = "A small description of the s3 static cdn purpose"
}

variable "price_class" {
  default     = "PriceClass_100"
  description = "Cloudfront price class"
}

variable "index_document" {
  default = "index.html"
}

variable "error_document" {
  default = "index.html"
}

# ---
variable "cache_policy_id" {
  description = "The cloudfront cache policy to use with default cache behaviour"
}

variable "origin_request_policy_id" {
  description = "The cloudfront origin request policy to use with default cache behaviour"
}

variable "response_headers_policy_id" {
  description = "The cloudfront response headers policy to use with default cache behaviour"
}

variable "is_preview" {
  description = "Whether this is a preview CDN or not"
  type        = bool
  default     = false
}

variable "preview_function_arn" {
  description = "The ARN of the cloudfront function responsible for url-rewrite and routing to previews s3 key"
  default     = null
}

# Logging
# --------
variable "s3_logging" {
  default = null
  type    = object({
    bucket  = string
    arn     = string
    address = string
  })
}
