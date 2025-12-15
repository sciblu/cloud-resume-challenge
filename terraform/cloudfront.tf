# ============================================================================
# CLOUDFRONT DISTRIBUTIONS
# ============================================================================

# ------------------------------------------------------------------------------
# ORIGIN ACCESS CONTROL - Secure connection between CloudFront and S3
# ------------------------------------------------------------------------------

resource "aws_cloudfront_origin_access_control" "www" {
  name                              = "OAC-${var.domain_name}"
  description                       = "OAC for www.${var.domain_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always" # Always sign requests
  signing_protocol                  = "sigv4"  # Use AWS Signature V4
}

# ------------------------------------------------------------------------------
# WWW CLOUDFRONT DISTRIBUTION - Main CDN for your website
# ------------------------------------------------------------------------------

resource "aws_cloudfront_distribution" "www" {
  enabled             = true # Turn on the distribution
  is_ipv6_enabled     = true # Support IPv6
  comment             = "CDN for www.${var.domain_name}"
  default_root_object = "index.html"    # Serve this for root URL
  price_class         = var.price_class # Which edge locations to use

  # Domain names this distribution responds to
  aliases = ["www.${var.domain_name}"]

  # Where to get the content from (your S3 bucket)
  origin {
    domain_name              = aws_s3_bucket.www.bucket_regional_domain_name
    origin_id                = "S3-www.${var.domain_name}"
    origin_access_control_id = aws_cloudfront_origin_access_control.www.id
  }

  # How to handle requests by default
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"] # Only allow read operations
    cached_methods         = ["GET", "HEAD"] # Cache these methods
    target_origin_id       = "S3-www.${var.domain_name}"
    viewer_protocol_policy = "redirect-to-https" # Force HTTPS
    compress               = true                # Enable gzip compression

    # Cache settings
    min_ttl     = 0        # Minimum cache time
    default_ttl = 86400    # Default: 1 day
    max_ttl     = 31536000 # Maximum: 1 year

    # Use managed cache policy for static content
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6" # CachingOptimized
  }

  # Custom error pages - important for single-page apps and Hugo
  custom_error_response {
    error_code            = 403         # Access Denied
    response_code         = 404         # Return as 404
    response_page_path    = "/404.html" # Your Hugo 404 page
    error_caching_min_ttl = 10          # Cache error for 10 seconds
  }

  custom_error_response {
    error_code            = 404 # Not Found
    response_code         = 404
    response_page_path    = "/404.html"
    error_caching_min_ttl = 10
  }

  # SSL/TLS certificate configuration
  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"     # Server Name Indication
    minimum_protocol_version = "TLSv1.2_2021" # Modern TLS only
  }

  # No geographic restrictions
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = "CDN-www.${var.domain_name}"
  }
}

# ------------------------------------------------------------------------------
# NAKED DOMAIN CLOUDFRONT DISTRIBUTION - Redirects to www
# ------------------------------------------------------------------------------

resource "aws_cloudfront_distribution" "naked" {
  enabled         = true
  is_ipv6_enabled = true
  comment         = "Redirect ${var.domain_name} to www"
  price_class     = var.price_class

  aliases = [var.domain_name]

  # Origin points to the redirect bucket
  origin {
    # For redirect buckets, use the website endpoint (not regional domain)
    domain_name = aws_s3_bucket_website_configuration.naked.website_endpoint
    origin_id   = "S3-${var.domain_name}"

    # Website endpoints require custom origin config (not S3 origin config)
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only" # S3 website endpoints are HTTP
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-${var.domain_name}"
    viewer_protocol_policy = "redirect-to-https"

    min_ttl     = 0
    default_ttl = 86400
    max_ttl     = 31536000

    # Forwarding values (needed for redirect)
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = "CDN-redirect-${var.domain_name}"
  }
}
