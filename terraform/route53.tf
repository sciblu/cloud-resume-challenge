# ============================================================================
# ROUTE 53 DNS RECORDS
# ============================================================================

# Reference the existing hosted zone (you already created this)
data "aws_route53_zone" "main" {
  zone_id = var.hosted_zone_id
}

# ------------------------------------------------------------------------------
# WWW RECORD - Points www.lahdigital.dev to CloudFront
# ------------------------------------------------------------------------------

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "www.${var.domain_name}"
  type    = "A" # IPv4 address record

  # Alias record - points to CloudFront without extra DNS lookup
  alias {
    name                   = aws_cloudfront_distribution.www.domain_name
    zone_id                = aws_cloudfront_distribution.www.hosted_zone_id
    evaluate_target_health = false # CloudFront handles health
  }
}



# ------------------------------------------------------------------------------
# NAKED DOMAIN RECORD - Points lahdigital.dev to redirect CloudFront
# ------------------------------------------------------------------------------

resource "aws_route53_record" "naked" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.naked.domain_name
    zone_id                = aws_cloudfront_distribution.naked.hosted_zone_id
    evaluate_target_health = false
  }
}

