/**
 * Output variables for the AWS Lambda function.
 * Author: Andrew Jarombek
 * Date: 11/28/2020
 */

output "lambda_invoke_arn" {
  value = aws_lambda_function.this.invoke_arn
}