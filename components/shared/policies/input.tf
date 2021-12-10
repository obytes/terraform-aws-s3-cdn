######################
#     VARIABLES      |
######################

# General
# --------
variable "prefix" {
  description = "Used for prefixing resources"
}

variable "common_tags" {
  type        = map(string)
  description = "Resources common tags"
}

variable "content_security_policy" {
  default = "default-src *; style-src 'self' 'unsafe-inline'; script-src 'self' 'unsafe-inline'; img-src 'self';"
}
