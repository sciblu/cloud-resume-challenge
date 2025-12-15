# ============================================================================
# VARIABLE DECLARATIONS
# ============================================================================

# Variables are declared here but values are set in terraform.tfvars
# Think of this as the "schema" - it defines what inputs exist

variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string      # This variable must be a string
  default     = "us-east-1" # Default value if not specified
}

variable "aws_profile" {
  description = "The AWS CLI profile to use for authentication"
  type        = string
  default     = "terraform-cloud-resume"
}

variable "domain_name" {
  description = "The root domain name (without www)"
  type        = string
  # No default - you MUST provide this value
  # Terraform will error if you don't

  # Validation ensures the value is reasonable
  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*\\.[a-z]{2,}$", var.domain_name))
    error_message = "Domain name must be a valid domain like 'example.com'."
  }
}

variable "hosted_zone_id" {
  description = "The Route 53 Hosted Zone ID for your domain"
  type        = string
  # You'll get this from your existing Route 53 hosted zone
  # It looks like: Z1234567890ABC
}

variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate (must be in us-east-1)"
  type        = string
  # You created this manually - get the ARN from the ACM console
  # It looks like: arn:aws:acm:us-east-1:123456789:certificate/abc-123-def
}

# ============================================================================
# OPTIONAL VARIABLES WITH SENSIBLE DEFAULTS
# ============================================================================

variable "environment" {
  description = "Environment name (production, staging, development)"
  type        = string
  default     = "production"
}

variable "price_class" {
  description = "CloudFront price class - affects which edge locations are used"
  type        = string
  default     = "PriceClass_All" # All edge locations

  # Other options:
  # PriceClass_100 = North America + Europe (cheapest)
  # PriceClass_200 = Above + Asia, Middle East, Africa
  # PriceClass_All = All edge locations (most expensive but fastest globally)
}