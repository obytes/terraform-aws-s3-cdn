#====================================#
#      Private Bucket                #
#====================================#
resource "aws_s3_bucket" "_" {
  bucket        = var.fqdn
  acl           = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled = true
  }

  tags          = local.common_tags
  force_destroy = true
}
