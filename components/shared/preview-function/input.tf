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
