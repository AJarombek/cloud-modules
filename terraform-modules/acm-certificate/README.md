### Overview

Module for setting up an Amazon Certificate Manager (ACM) certificate.  The Certificate is validated with DNS.

### Use Case

```hcl-terraform
module "acm-certificate" {
  source = "github.com/ajarombek/cloud-modules//terraform-modules/acm-certificate?ref=v0.2.13"

  # Mandatory arguments
  name = "example-acm"
  route53_zone_name = "sample.com."
  acm_domain_name = "*.sample.com"

  # Optional arguments
  route53_zone_private = false
  cert_validation_enabled = true
  
  tags = {
    Name = "example-acm"
    Application = "sample-app"
    Environment = "sandbox"
    Terraform = local.terraform_tag
  }
}
```

### Files

| Filename                 | Description                                                                 |
|--------------------------|-----------------------------------------------------------------------------|
| `main.tf`                | The main Terraform file of the module used to create the ACM certificate.   |
| `outputs.tf`             | Output values that are likely needed outside the module.                    |
| `var.tf`                 | Variables needed to customize the ACM Certificate.                          |