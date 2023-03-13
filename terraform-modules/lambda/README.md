### Overview

Module for creating an AWS Lambda function with cloudwatch logs and provisioned concurrency.

### Use Case

```hcl-terraform
module "lambda" {
  source = "github.com/ajarombek/cloud-modules//terraform-modules/lambda?ref=v0.2.14"

  # Mandatory arguments
  function_name = "example"
  filename = "${path.module}/example.zip"
  iam_role_arn = aws_iam_role.lambda-role.arn

  # Optional arguments
  handler = "function.lambda_handler"
  runtime = "python3.8"
  memory_size = 128
  timeout = 10
  
  env_vars = {
    ENV = "sandbox"
  }

  provisioned_concurrency = true
  provisioned_concurrent_executions = 1

  logs_retention_in_days = 7

  tags = {
    Name = "example"
    Environment = "sandbox"
    Application = "example"
    Terraform = local.terraform_tag
  }
}
```

### Files

| Filename                 | Description                                                                     |
|--------------------------|---------------------------------------------------------------------------------|
| `main.tf`                | The main Terraform file of the module used to create the AWS Lambda function.   |
| `outputs.tf`             | Output values that are likely needed outside the module.                        |
| `var.tf`                 | Variables needed to customize the AWS Lambda function.                          |