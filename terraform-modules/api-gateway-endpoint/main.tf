/**
 * Module for creating an API Gateway endpoint.
 * Author: Andrew Jarombek
 * Date: 11/24/2020
 */

resource "aws_api_gateway_resource" "resource" {
  rest_api_id = var.rest_api_id
  parent_id   = var.parent_path_id
  path_part   = var.path
}

resource "aws_api_gateway_method" "method" {
  rest_api_id          = var.rest_api_id
  resource_id          = aws_api_gateway_resource.resource.id
  request_validator_id = aws_api_gateway_request_validator.request-validator.id

  http_method   = var.http_method
  authorization = var.authorization
  authorizer_id = var.authorizer_id
}

resource "aws_api_gateway_request_validator" "request-validator" {
  rest_api_id                 = var.rest_api_id
  validate_request_body       = var.validate_request_body
  validate_request_parameters = var.validate_request_parameters
  name                        = var.request_validator_name
}

resource "aws_api_gateway_method_response" "method-response" {
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.resource.id

  http_method = aws_api_gateway_method.method.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.resource.id

  http_method = aws_api_gateway_method.method.http_method

  # Lambda functions can only be invoked via HTTP POST
  integration_http_method = "POST"

  type = "AWS"
  uri  = var.lambda_invoke_arn

  content_handling = var.content_handling

  request_templates = var.request_templates
}

resource "aws_api_gateway_integration_response" "integration-response" {
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_resource.resource.id

  http_method = aws_api_gateway_method.method.http_method
  status_code = aws_api_gateway_method_response.method-response.status_code

  response_templates = {
    "application/json" = var.response_template
  }

  depends_on = [
    aws_api_gateway_integration.integration
  ]
}