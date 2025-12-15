# ============================================================================
# CLOUD RESUME CHALLENGE - MAIN CONFIGURATION
# ============================================================================
#
# This Terraform configuration creates:
#   1. S3 bucket for website content (www.lahdigital.dev)
#   2. S3 bucket for redirect (lahdigital.dev → www)
#   3. CloudFront distribution for www with OAC
#   4. CloudFront distribution for naked domain redirect
#   5. Route 53 DNS records
#
# Prerequisites:
#   - Domain registered and Route 53 hosted zone created
#   - ACM certificate created (wildcard *.lahdigital.dev) in us-east-1
#   - AWS CLI configured with appropriate credentials
#
# Author: LH
# Project: Cloud Resume Challenge
# ============================================================================

# This file intentionally left mostly empty.
# The configuration is organized into separate files:
#   - providers.tf  → Terraform and AWS provider configuration
#   - variables.tf  → Variable declarations
#   - s3.tf         → S3 bucket resources
#   - cloudfront.tf → CloudFront distributions
#   - route53.tf    → DNS records
#   - outputs.tf    → Output values
#
# Terraform automatically loads all .tf files in the directory.