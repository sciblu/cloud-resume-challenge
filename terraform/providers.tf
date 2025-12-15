# ============================================================================
# TERRAFORM AND PROVIDER CONFIGURATION
# ============================================================================

# This block specifies which version of Terraform and which providers we need
terraform {
  # Require Terraform version 1.0 or higher
  # The ~> means "approximately equal to" - allows 1.0.x, 1.1.x, etc. but not 2.0
  required_version = "~> 1.14.2"

  # Declare the providers (cloud platforms) this configuration uses
  required_providers {
    aws = {
      source  = "hashicorp/aws" # Official AWS provider from HashiCorp
      version = "~> 5.0"        # Use version 5.x (latest stable)
    }
  }

  # OPTIONAL: Store Terraform state remotely in S3
  # Uncomment this after you create the state bucket manually
  # backend "s3" {
  #   bucket         = "lahdigital-terraform-state"
  #   key            = "cloud-resume/terraform.tfstate"
  #   region         = "us-east-1"
  #   encrypt        = true
  #   dynamodb_table = "terraform-state-lock"
  #   profile        = "terraform-cloud-resume"
  # }
}

# Configure the AWS provider
provider "aws" {
  region  = var.aws_region  # Use the region from variables
  profile = var.aws_profile # Use the named profile we created

  # Default tags applied to ALL resources created by this configuration
  # This helps with cost tracking and resource identification
  default_tags {
    tags = {
      Project     = "Cloud Resume Challenge"
      ManagedBy   = "Terraform"
      Environment = "Production"
      Owner       = "LH"
    }
  }
}

# Second AWS provider for us-east-1 specifically
# CloudFront requires ACM certificates to be in us-east-1
# Even if your main region is different, you need this
provider "aws" {
  alias   = "us_east_1" # Give it a name we can reference
  region  = "us-east-1" # Force this provider to us-east-1
  profile = var.aws_profile

  default_tags {
    tags = {
      Project     = "Cloud Resume Challenge"
      ManagedBy   = "Terraform"
      Environment = "Production"
      Owner       = "LH"
    }
  }
}

