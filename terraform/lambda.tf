# =============================================================================
# LAMBDA FUNCTION
# =============================================================================
# The serverless function that handles visitor counting

# -----------------------------------------------------------------------------
# PACKAGE LAMBDA CODE
# -----------------------------------------------------------------------------
# Lambda expects code as a ZIP file. This data source creates that ZIP
# from your Python file without you manually zipping it.

data "archive_file" "lambda_zip" {
  type        = "zip"                                       # Output format
  source_file = "${path.module}/lambda/visitor_counter.py"  # Your Python file
  output_path = "${path.module}/lambda/visitor_counter.zip" # Where to save ZIP
}

# -----------------------------------------------------------------------------
# LAMBDA FUNCTION RESOURCE
# -----------------------------------------------------------------------------
# The actual Lambda function that runs your code

resource "aws_lambda_function" "visitor_counter" {
  # Function name as it appears in AWS Console
  function_name = "visitor-counter"
  
  # The IAM role this function assumes when running
  role = aws_iam_role.lambda_role.arn
  
  # Handler tells Lambda which function to call
  # Format: filename.function_name (without .py extension)
  # So "visitor_counter.lambda_handler" means:
  #   - Look in visitor_counter.py
  #   - Call the lambda_handler function
  handler = "visitor_counter.lambda_handler"
  
  # Runtime specifies the language/version
  runtime = "python3.11"
  
  # Path to the ZIP file containing your code
  filename = data.archive_file.lambda_zip.output_path
  
  # source_code_hash tells Terraform to update Lambda when code changes
  # Without this, Terraform wouldn't notice code changes (only config changes)
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  
  # Environment variables available to your code via os.environ
  environment {
    variables = {
      # This is how the Python code knows which table to use
      TABLE_NAME = aws_dynamodb_table.visitor_counter.name
    }
  }
  
  # Timeout in seconds - how long Lambda can run before being killed
  # 10 seconds is plenty for a simple database read/write
  timeout = 10
  
  # Memory allocation in MB - also affects CPU proportionally
  # 128MB is the minimum and sufficient for this simple function
  memory_size = 128
  
  tags = {
    Name    = "visitor-counter"
    Project = "cloud-resume"
  }
}

# -----------------------------------------------------------------------------
# LAMBDA PERMISSION FOR API GATEWAY
# -----------------------------------------------------------------------------
# Lambda needs explicit permission to be invoked by other services
# This grants API Gateway permission to call our Lambda

resource "aws_lambda_permission" "api_gateway_permission" {
  # A friendly name for this permission
  statement_id = "AllowAPIGatewayInvoke"
  
  # The action being permitted
  action = "lambda:InvokeFunction"
  
  # Which Lambda function this permission applies to
  function_name = aws_lambda_function.visitor_counter.function_name
  
  # Which service is allowed to invoke (API Gateway)
  principal = "apigateway.amazonaws.com"
  
  # source_arn restricts which specific API can invoke
  # Format: arn:aws:execute-api:region:account:api-id/stage/method/path
  # The /*/* at the end means "any stage, any method, any path"
  source_arn = "${aws_apigatewayv2_api.visitor_api.execution_arn}/*/*"
}
