# =============================================================================
# DYNAMODB TABLE
# =============================================================================
# DynamoDB is a NoSQL database - perfect for simple key-value storage like a counter
# It's serverless (no servers to manage) and scales automatically

resource "aws_dynamodb_table" "visitor_counter" {
  # The name of the table in AWS
  name = "visitor-counter"
  
  # Billing mode: PAY_PER_REQUEST means you only pay for actual reads/writes
  # No need to guess capacity - perfect for unpredictable traffic
  # Alternative is PROVISIONED where you set fixed read/write capacity
  billing_mode = "PAY_PER_REQUEST"
  
  # Hash key is the partition key - the primary way to look up items
  # Every item in the table must have this attribute
  hash_key = "id"
  
  # Attribute definitions describe the key schema
  # We only need to define attributes used in keys
  attribute {
    name = "id"      # The attribute name
    type = "S"       # S = String (N = Number, B = Binary)
  }
  
  # Tags for organization and cost tracking
  tags = {
    Name    = "visitor-counter"
    Project = "cloud-resume"
  }
}
