/**
 * Varaibles for creating an API Gateway endpoint
 * Author: Andrew Jarombek
 * Date: 11/24/2020
 */

variable "rest_api_id" {
  description = "An identifier for the API Gateway REST API."
  type        = string
}

variable "parent_path_id" {
  description = "An identifier for the path which is a direct parent for this endpoint in the REST API."
  type        = string
}

variable "path" {
  description = "The path for this endpoint in the REST API."
  type        = string
}

variable "http_method" {
  description = "The http method of the API Gateway endpoint."
  type        = string
  default     = "POST"
}

variable "validate_request_body" {
  description = "Whether the HTTP request body should be validated."
  type        = bool
  default     = false
}

variable "validate_request_parameters" {
  description = "Whether the HTTP request parameters should be validated."
  type        = bool
  default     = false
}

variable "request_validator_name" {
  description = "The name of the request validator."
  type        = string
}

variable "request_templates" {
  description = "Velocity templates for the incoming request.  Each template is matched to a MIME type."
  type        = map(any)
  default     = {}
}

variable "response_template" {
  description = "Velocity template for the outgoing response.  Converts the response into JSON for the client."
  type        = string
}

variable "lambda_invoke_arn" {
  description = "AWS Lambda ARN for the API Gateway endpoint to invoke."
  type        = string
}

variable "content_handling" {
  description = "Specifies how to handle request payload content type conversions."
  type        = string
  default     = null
}

variable "authorization" {
  description = "Type of authorization used for the API Gateway method."
  type        = string
  default     = "NONE"

  validation {
    condition     = can(regex("NONE|CUSTOM|AWS_IAM|COGNITO_USER_POOLS", var.authorization))
    error_message = "The type of authorization specified is invalid."
  }
}

variable "authorizer_id" {
  description = "The custom authorizer id to use when the authorizer type is CUSTOM."
  type        = string
  default     = null
}