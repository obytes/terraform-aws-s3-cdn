output "main_webapp_envs_sm_id" {
  value = module.webapp_main_ci.*.envs_sm_id
}

output "preview_webapp_envs_sm_id" {
  value = module.webapp_pr_preview_ci.*.envs_sm_id
}

output "cloudfront_key_group_id" {
  value = module.webapp_private_media_signer.cloudfront_key_group_id
}

output "cloudfront_public_key_id" {
  value = module.webapp_private_media_signer.cloudfront_public_key_id
}

output "main_cdn_dist" {
  value = module.webapp_main_cdn.*.dist
}

output "preview_cdn_dist" {
  value = module.webapp_pr_preview_cdn.*.dist
}

output "private_media_cdn_dist" {
  value = module.webapp_media_cdn.*.dist
}

output "public_media_cdn_dist" {
  value = module.webapp_public_media_cdn.*.dist
}
