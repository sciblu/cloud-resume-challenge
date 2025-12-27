# =============================================================================
# IAM RESOURCES FOR LAMBDA
# =============================================================================
# These resources define what permissions the Lambda function has

# -----------------------------------------------------------------------------
# IAM ROLE - The identity Lambda assumes when running
# -----------------------------------------------------------------------------
resource "aws_iam_role" "lambda_role" {
  name = "visitor-counter-lambda-role"
  
  # assume_role_policy answers: "WHO can use this role?"
  # This policy says "Lambda service can assume (use) this role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"    # Policy language version (always use this)
    Statement = [
      {
        Action = "sts:AssumeRole"           # The permission to assume the role
        Effect = "Allow"                     # Allow (not Deny)
        Principal = {
          Service = "lambda.amazonaws.com"   # Only Lambda service can assume this
        }
      }
    ]
  })

  tags = {
    Name    = "visitor-counter-lambda-role"
    Project = "cloud-resume"
  }
}

# -----------------------------------------------------------------------------
# IAM POLICY - DynamoDB access permissions
# -----------------------------------------------------------------------------
# The role above says WHO can use it. This policy says WHAT they can do.
# We're granting permission to read/write our specific DynamoDB table.

resource "aws_iam_policy" "lambda_dynamodb_policy" {
  name        = "visitor-counter-dynamodb-policy"
  description = "Allows Lambda to read and write to the visitor counter DynamoDB table"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        # These are the specific DynamoDB actions we need:
        Action = [
          "dynamodb:GetItem",      # Read a single item
          "dynamodb:PutItem",      # Create/replace an item  
          "dynamodb:UpdateItem",   # Update an existing item (what we use)
          "dynamodb:DeleteItem"    # Delete an item (not needed, but useful for testing)
        ]
        # Resource specifies WHICH table - only our visitor-counter table
        # This follows "principle of least privilege" - only grant what's needed
        Resource = aws_dynamodb_table.visitor_counter.arn
      }
    ]
  })

  tags = {
    Name    = "visitor-counter-dynamodb-policy"
    Project = "cloud-resume"
  }
}

# -----------------------------------------------------------------------------
# POLICY ATTACHMENTS - Connect policies to the role
# -----------------------------------------------------------------------------

# Attach DynamoDB policy to Lambda role
resource "aws_iam_role_policy_attachment" "lambda_dynamodb_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_dynamodb_policy.arn
}

# Attach CloudWatch Logs policy (AWS-managed)
# Lambda automatically sends logs to CloudWatch, but needs permission
# This is essential for debugging when things go wrong
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
