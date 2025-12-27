# =============================================================================
# API GATEWAY HTTP API
# =============================================================================
# API Gateway creates a public URL that triggers your Lambda
# HTTP API (v2) is simpler and cheaper than REST API (v1)

# -----------------------------------------------------------------------------
# HTTP API
# -----------------------------------------------------------------------------
resource "aws_apigatewayv2_api" "visitor_api" {
  name          = "visitor-counter-api"
  protocol_type = "HTTP"    # HTTP API (not WEBSOCKET)
  
  # CORS configuration - handles browser security automatically
  # Without this, browsers block cross-origin requests
  cors_configuration {
    # Which domains can call this API
    # Use your actual domain in production for security
    allow_origins = ["https://lahdigital.dev", "https://www.lahdigital.dev"]
    
    # Which HTTP methods are allowed
    allow_methods = ["GET", "POST", "OPTIONS"]
    
    # Which headers clients can send
    allow_headers = ["Content-Type"]
    
    # How long browsers cache CORS preflight responses (in seconds)
    max_age = 300
  }

}

# -----------------------------------------------------------------------------
# INTEGRATION - Connects API Gateway to Lambda
# -----------------------------------------------------------------------------
# It defines HOW requests get passed to Lambda

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id = aws_apigatewayv2_api.visitor_api.id
  
  # AWS_PROXY means API Gateway passes the entire request to Lambda
  # and Lambda's response goes directly back to the client
  integration_type = "AWS_PROXY"
  
  # URI of the Lambda function to invoke
  integration_uri = aws_lambda_function.visitor_counter.invoke_arn
  
  # How API Gateway sends requests to Lambda
  # POST is required for Lambda proxy integration (even for GET requests to API)
  integration_method = "POST"
  
  # 2.0 is the newer payload format with cleaner structure
  payload_format_version = "2.0"
}

# -----------------------------------------------------------------------------
# ROUTE - Defines the URL path and HTTP method
# -----------------------------------------------------------------------------
resource "aws_apigatewayv2_route" "visitor_route" {
  api_id = aws_apigatewayv2_api.visitor_api.id
  
  # Route key format: "METHOD /path"
  # GET /count means HTTP GET requests to /count trigger this route
  route_key = "GET /count"
  
  # Which integration handles requests to this route
  target = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# -----------------------------------------------------------------------------
# STAGE - A deployment of your API (like dev, staging, prod)
# -----------------------------------------------------------------------------
resource "aws_apigatewayv2_stage" "default_stage" {
  api_id = aws_apigatewayv2_api.visitor_api.id
  
  # $default means no stage prefix in URL
  # With named stage "prod", URL would be: .../prod/count
  # With $default, URL is just: .../count
  name = "$default"
  
  # auto_deploy automatically deploys changes when you modify the API
  # Without this, changes wouldn't go live until manually deployed
  auto_deploy = true

}
