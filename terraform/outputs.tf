# ============================================================================
# OUTPUTS - Information displayed after terraform apply
# ============================================================================

output "www_bucket_name" {
  description = "Name of the S3 bucket hosting website content"
  value       = aws_s3_bucket.www.id
}

output "www_cloudfront_distribution_id" {
  description = "CloudFront distribution ID (needed for cache invalidation)"
  value       = aws_cloudfront_distribution.www.id
}

output "www_cloudfront_domain" {
  description = "CloudFront domain name"
  value       = aws_cloudfront_distribution.www.domain_name
}

output "website_url" {
  description = "Your website URL"
  value       = "https://www.${var.domain_name}"
}

output "naked_domain_url" {
  description = "Naked domain URL (redirects to www)"
  value       = "https://${var.domain_name}"
}

# Outputs needed for GitHub Actions
output "github_actions_config" {
  description = "Values needed for GitHub Actions deployment"
  value = {
    bucket_name     = aws_s3_bucket.www.id
    distribution_id = aws_cloudfront_distribution.www.id
    aws_region      = var.aws_region
  }
}
