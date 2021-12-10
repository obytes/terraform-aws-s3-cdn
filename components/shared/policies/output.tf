output "cache_policy_id" {
  value = aws_cloudfront_cache_policy._.id
}

output "origin_request_policy_id" {
  value = aws_cloudfront_origin_request_policy._.id
}

output "response_headers_policy_id" {
  value = aws_cloudfront_response_headers_policy._.id
}
