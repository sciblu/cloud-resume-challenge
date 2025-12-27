# =============================================================================
# API GATEWAY CUSTOM DOMAIN
# =============================================================================
# This configures a custom subdomain (api-counter.yourdomain.com) for the API
# Instead of the default AWS URL like: https://abc123.execute-api.us-east-1.amazonaws.com

# -----------------------------------------------------------------------------
# CUSTOM DOMAIN NAME
# -----------------------------------------------------------------------------
# Creates the custom domain in API Gateway
# Uses your existing wildcard certificate (*.lahdigital.dev)

resource "aws_apigatewayv2_domain_name" "api" {
  domain_name = "api-counter.${var.domain_name}"
  
  # TLS certificate configuration
  domain_name_configuration {
    certificate_arn = var.acm_certificate_arn  # Your wildcard cert covers this!
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }

  tags = {
    Name        = "api-counter-domain"
    Environment = var.environment
  }
}

# -----------------------------------------------------------------------------
# API MAPPING
# -----------------------------------------------------------------------------
# Maps the custom domain to your API Gateway stage
# This tells API Gateway: "when requests come to api-counter.domain.com, route them to this API"

resource "aws_apigatewayv2_api_mapping" "api" {
  api_id      = aws_apigatewayv2_api.visitor_api.id
  domain_name = aws_apigatewayv2_domain_name.api.id
  stage       = aws_apigatewayv2_stage.default_stage.id
}

# -----------------------------------------------------------------------------
# ROUTE 53 DNS RECORD
# -----------------------------------------------------------------------------
# Points your subdomain to API Gateway's endpoint

resource "aws_route53_record" "api" {
  zone_id = var.hosted_zone_id
  name    = "api-counter.${var.domain_name}"
  type    = "A"
  
  alias {
    name                   = aws_apigatewayv2_domain_name.api.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.api.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}
