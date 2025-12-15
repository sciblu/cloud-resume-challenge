# ============================================================================
# S3 BUCKETS FOR STATIC WEBSITE HOSTING
# ============================================================================

# ------------------------------------------------------------------------------
# WWW BUCKET - This holds your actual Hugo website files
# ------------------------------------------------------------------------------

# Create the bucket
resource "aws_s3_bucket" "www" {
  bucket = "www.${var.domain_name}" # Results in: www.lahdigital.dev

  # Prevent accidental deletion - Terraform will error if you try to destroy
  # a non-empty bucket. Remove this line if you need to destroy the bucket.
  force_destroy = false

  tags = {
    Name    = "www.${var.domain_name}"
    Purpose = "Hugo website content"
  }
}

# Block ALL public access - CloudFront will access via OAC, not public URLs
resource "aws_s3_bucket_public_access_block" "www" {
  bucket = aws_s3_bucket.www.id # Reference the bucket we just created

  block_public_acls       = true # Block public ACLs
  block_public_policy     = true # Block public bucket policies
  ignore_public_acls      = true # Ignore any public ACLs
  restrict_public_buckets = true # Restrict public bucket policies
}

# Set bucket ownership controls
resource "aws_s3_bucket_ownership_controls" "www" {
  bucket = aws_s3_bucket.www.id

  rule {
    object_ownership = "BucketOwnerEnforced" # Disable ACLs entirely
  }
}


# Bucket policy - allows CloudFront to read objects
resource "aws_s3_bucket_policy" "www" {
  bucket = aws_s3_bucket.www.id

  # This policy is created AFTER the CloudFront OAC exists
  depends_on = [aws_s3_bucket_public_access_block.www]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.www.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.www.arn
          }
        }
      }
    ]
  })
}

# ------------------------------------------------------------------------------
# NAKED DOMAIN BUCKET - Redirects to www
# ------------------------------------------------------------------------------

# Create the redirect bucket
resource "aws_s3_bucket" "naked" {
  bucket = var.domain_name # Results in: lahdigital.dev

  tags = {
    Name    = var.domain_name
    Purpose = "Redirect to www"
  }
}

# This bucket CAN be public because it only redirects (no content)
resource "aws_s3_bucket_public_access_block" "naked" {
  bucket = aws_s3_bucket.naked.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Enable static website hosting with redirect
resource "aws_s3_bucket_website_configuration" "naked" {
  bucket = aws_s3_bucket.naked.id

  redirect_all_requests_to {
    host_name = "www.${var.domain_name}" # Redirect to www.lahdigital.dev
    protocol  = "https"                  # Force HTTPS
  }
}