/**
 * Variables for creating an AWS Lambda function.
 * Author: Andrew Jarombek
 * Date: 11/28/2020
 */

variable "function_name" {
  description = "The name of the AWS Lambda function."
  type        = string
}

variable "filename" {
  description = "The file path for the distributable AWS Lambda file."
  type        = string
}

variable "iam_role_arn" {
  description = "ARN of the IAM role for the Lambda function."
  type        = string
}

variable "handler" {
  description = "The name of the handler (file and method name) of the AWS Lambda function."
  type        = string
  default     = "function.lambda_handler"
}

variable "runtime" {
  description = "The runtime (programming language and version) of the AWS Lambda function."
  type        = string
  default     = "python3.8"

  validation {
    condition     = contains(["nodejs12.x", "java11", "python3.7", "python3.8", "dotnetcore3.1", "go1.x", "ruby2.7"], var.runtime)
    error_message = "Invalid AWS Lambda runtime specified."
  }
}

variable "memory_size" {
  description = "The amount of memory in MBs allocated for the function."
  type        = number
  default     = 128
}

variable "timeout" {
  description = "Length of time when the function times out."
  type        = number
  default     = 10
}

variable "env_vars" {
  description = "The environment variables of the AWS Lambda function."
  type        = map(any)
  default     = {}
}

variable "provisioned_concurrency" {
  description = "Whether the AWS Lambda function has provisioned concurrency."
  type        = bool
  default     = false
}

variable "provisioned_concurrent_executions" {
  description = "The number of concurrent executions provisioned."
  type        = number
  default     = 1
}

variable "logs_retention_in_days" {
  description = "The number of days that function logs exist in Cloudwatch."
  type        = number
  default     = 7
}

variable "tags" {
  description = "Tags for the lambda function and Cloudwatch logs."
  type        = map(any)
  default     = {}
}