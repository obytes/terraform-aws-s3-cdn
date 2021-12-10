output "cloudfront_key_group_id" {
  value = aws_cloudfront_key_group._.id
}

output "cloudfront_public_key_id" {
  value = aws_cloudfront_public_key._.id
}
