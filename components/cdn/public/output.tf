output "s3" {
  value = {
    id     = aws_s3_bucket._.id
    arn    = aws_s3_bucket._.arn
    bucket = aws_s3_bucket._.bucket
  }
}

output "dist" {
  value = {
    id          = aws_cloudfront_distribution._.id
    arn         = aws_cloudfront_distribution._.arn
    zone_id     = aws_cloudfront_distribution._.hosted_zone_id
    domain_name = aws_cloudfront_distribution._.domain_name
  }
}
