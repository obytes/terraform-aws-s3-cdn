# Terraform AWS S3 CDN

Reusable Terraform module for deploying, previewing and serving public static web applications and private media.

## Components

- **Main CDN**: Provides a cloudfront distribution to serve public static web applications.

- **Preview CDN**: Like Netlify, provides a cloudfront distribution to preview Github feature branches that has an open PR.

- **Media CDN**: Provides a cloudfront distribution to serve public media, or private media using pre-signed URLs.

- **Policies**: Provides a cache optimized policy, an origin request policy and a response headers policy to improve 
  performance and secure content.
  
- **Preview Function**: Provides a viewer request cloudfront function for url re-writing and routing the wildcard preview
  domain requests into the target preview content.

## Features

✅ Thanks to Brotli and GZip compression, Improve application performance by delivering content faster to viewers using 
smaller file sizes.

✅ Reduce the number of requests that the origin S3 service must respond to directly. Thanks to CloudFront caching and 
the cache optimized policy, objects are served from CloudFront edge locations, which are closer to your users.

✅ Provide a response headers policy to secure your application’s communications and customize its behavior. with CORS 
to control access to origin objects, and Security Headers to exchange security-related information.

✅ Protect and serve private media using Cloudfront signed URLs.

✅ Support Route53 and Cloudflare as DNS providers (If you want to use another DNS provider, you can call the components 
directly).

✅ Auto provision the DNS records for the main, preview and the media CDNs.

✅ Routing the preview requests to the target preview content based on the host header thanks to the wildcard domain and
cloudfront preview function.

✅ Ability to conditionally provision the main, preview and media CDNs components using the `enable` Terraform map 
variable.

## Indirect Features

✅ Improving the search rankings for web application and help meet regulatory compliance requirements for encrypting
data in transit by acquiring and auto validation of an SSL/TLS certificate for main/preview/media CDNs domains.

✅ Provide a CI/CD pipeline for deploying the static web applications developed with any framework 
(ReactJS, VueJS, Hugo, Gatsby ...)

## Used Services:

- AWS S3
- AWS Cloudfront
- AWS Lambda Functions 
- AWS Codebuild
- AWS Codepipeline
- AWS Certificate Manger
- AWS Route53 or Cloudflare
- Github

## Usage

This is an example to provision the main, preview and media CDNs along with their CI/CD pipelines, route53 records and 
domains certification.

```hcl
module "demo_webapp" {
  source      = "git::https://github.com/obytes/terraform-aws-s3-cdn//modules/route53"
  prefix      = "${local.prefix}-demo"
  common_tags = local.common_tags

  comment = "Demo wep application"

  enable = {
    main    = true
    preview = true
    media   = true
  }

  dns_zone_id = aws_route53_zone._.zone_id
  main_fqdn   = "demo.kodhive.com"
  media_fqdn  = "demo-private-media.kodhive.com"

  media_signer_public_key = file("${path.module}/public_key.pem")
  content_security_policy = "default-src * 'unsafe-inline'"

  # Artifacts
  s3_artifacts = {
    arn    = aws_s3_bucket.artifacts.arn
    bucket = aws_s3_bucket.artifacts.bucket
  }

  # Github
  github            = {
    owner          = "obytes"
    token          = "Token used to comment on github PRs when the preview is ready!"
    webhook_secret = "not-secret"
    connection_arn = "arn:aws:codestar-connections:us-east-1:{ACCOUNT_ID}:connection/{CONNECTION_ID}"
  }
  pre_release       = false
  github_repository = {
    name   = "react-typescript-starter"
    branch = "main"
  }

  # Build
  app_base_dir          = "."
  app_build_dir         = "build"
  app_node_version      = "latest"
  app_install_cmd       = "yarn install"
  app_build_cmd         = "yarn build"

  # Notification
  ci_notifications_slack_channels = {
    info  = "ci-info"
    alert = "ci-alert"
  }
}
```

> This example is using route53 Terraform module. If you are using cloudflare, you can switch to the cloudflare module.

You should also update the application's DOT Env environments variables pulled from secrets manager through terraform or 
directly from AWS Console.

```hcl
resource "aws_secretsmanager_secret_version" "main_webapp_env_vars" {
  secret_id     = module.demo_webapp.main_webapp_envs_sm_id[0]
  secret_string = jsonencode({
    REACT_APP_FIREBASE_API_KEY     = "REACT_APP_FIREBASE_API_KEY"
    REACT_APP_FIREBASE_PROJECT_ID  = "REACT_APP_FIREBASE_PROJECT_ID"
    REACT_APP_FIREBASE_AUTH_DOMAIN = "REACT_APP_FIREBASE_AUTH_DOMAIN"
  })
}

resource "aws_secretsmanager_secret_version" "preview_webapp_env_vars" {
  secret_id     = module.demo_webapp.preview_webapp_envs_sm_id[0]
  secret_string = jsonencode({
    REACT_APP_FIREBASE_API_KEY     = "REACT_APP_FIREBASE_API_KEY"
    REACT_APP_FIREBASE_PROJECT_ID  = "REACT_APP_FIREBASE_PROJECT_ID"
    REACT_APP_FIREBASE_AUTH_DOMAIN = "REACT_APP_FIREBASE_AUTH_DOMAIN"
  })
}
```

> Better to not manage this resource with terraform and let users modify secrets directly from the console.
