# General
# --------
variable "prefix" {
  description = "Used for prefixing resources"
}

variable "common_tags" {
  type        = map(string)
  description = "Resources common tags"
}

variable "fqdn" {
  description = "The fully qualified domain name will be used as bucket name and as domain alias if no domain aliases is provided, eg: assets.kodhive.com or kodhive.com"
}

variable "s3_logging" {
  description = "The s3 bucket name used for cloudfront logging"
  default     = null
  type        = object({
    bucket  = string
    arn     = string
    address = string
  })
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

variable "default_root_object" {
  default = "index.html"
}

variable "cert_arn" {
  description = "ACM certificate used with cloudfront SSL it should be in us-east-1"
}

variable "trusted_key_groups" {
  type        = list(string)
  description = "A list of key groups trusted to generate cloudfront presigned urls, set this only if content is user specific"
  default     = [ ]
}

variable "domain_aliases" {
  type        = list(string)
  description = "A list of domain aliases that will act as cloudfront aliases eg. [ assets.kodhive.com, static.kodhive.com, media.kodhive.com .... ] "
  default     = [ ]
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
