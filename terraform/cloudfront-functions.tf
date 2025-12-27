# =============================================================================
# CLOUDFRONT FUNCTION - URL REWRITE
# =============================================================================
# Rewrites URLs to append index.html for clean URLs
# Example: /about → /about/index.html

resource "aws_cloudfront_function" "rewrite" {
  name    = "rewrite-index-html"           # Matches your existing function name
  runtime = "cloudfront-js-2.0"            # CloudFront Functions JavaScript runtime
  publish = true                           # Publish immediately (makes it live)
  comment = "Rewrites URLs to append index.html for directory paths"
  
  # Reads the function code from the external file
  code = file("${path.module}/functions/rewrite-index-html.js")
}