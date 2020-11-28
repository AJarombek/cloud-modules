/**
 * Module for creating an AWS Lambda function.
 * Author: Andrew Jarombek
 * Date: 11/28/2020
 */

resource "aws_lambda_function" "this" {
  function_name = var.function_name
  filename = var.filename
  handler = var.handler
  role = var.iam_role_arn
  runtime = var.runtime
  source_code_hash = filebase64sha256(var.filename)
  memory_size = var.memory_size
  timeout = var.timeout
  publish = true

  environment {
    variables = var.env_vars
  }

  tags = var.tags
}

resource "aws_lambda_alias" "this" {
  function_name = aws_lambda_function.this.function_name
  function_version = aws_lambda_function.this.version
  name = "${var.function_name}Current"
}

resource "aws_lambda_provisioned_concurrency_config" "this" {
  count = var.provisioned_concurrency ? 1 : 0

  function_name = aws_lambda_function.this.function_name
  provisioned_concurrent_executions = var.provisioned_concurrent_executions
  qualifier = aws_lambda_alias.this.name
}

resource "aws_cloudwatch_log_group" "this" {
  name = "/aws/lambda/${var.function_name}"
  retention_in_days = var.logs_retention_in_days

  tags = var.tags
}