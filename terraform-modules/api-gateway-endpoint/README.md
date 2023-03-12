### Overview

Module for setting up an endpoint in an API Gateway REST API.  The endpoint is backed by an existing AWS Lambda function.

### Use Case

```hcl-terraform
module "api-gateway-endpoint" {
  source = "github.com/ajarombek/cloud-modules//terraform-modules/api-gateway-endpoint?ref=v0.2.13"

  # Mandatory arguments
  rest_api_id = aws_api_gateway_rest_api.example.id
  parent_path_id = aws_api_gateway_resource.example-path.id
  path = "example"
  request_validator_name = "example-validator"
  
  request_template = {
    "application/json" = file("request.vm")
  }

  response_template = file("response.vm")

  lambda_invoke_arn = aws_lambda_function.example.invoke_arn

  # Optional arguments
  http_method = "POST"
  validate_request_body = true
  validate_request_parameters = false
  content_handling = "CONVERT_TO_TEXT"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.example.id
}
```

### Files

| Filename                 | Description                                                                     |
|--------------------------|---------------------------------------------------------------------------------|
| `main.tf`                | The main Terraform file of the module used to create the API Gateway endpoint.  |
| `outputs.tf`             | Output values that are likely needed outside the module.                        |
| `var.tf`                 | Variables needed to customize the API Gateway endpoint.                         |