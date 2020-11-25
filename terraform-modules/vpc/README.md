### Overview

Module for setting up a VPC and all the appropriate security infrastructure.

### Use Case

```hcl-terraform
module "vpc" {
  source = "github.com/ajarombek/cloud-modules//terraform-modules/vpc?ref=v0.1.6"

  # Mandatory arguments
  name = "example-vpc"
  tag_name = "example-vpc"

  # Optional arguments
  public_subnet_count = 2
  private_subnet_count = 2
  enable_dns_support = true
  enable_dns_hostnames = true
  enable_nat_gateway = false

  public_subnet_names = ["subnet0", "subnet1"]
  private_subnet_names = ["subnet2", "subnet3"]

  public_subnet_azs = local.example_public_subnet_azs
  private_subnet_azs = local.example_private_subnet_azs
  public_subnet_cidrs = local.example_public_subnet_cidrs
  private_subnet_cidrs = local.example_private_subnet_cidrs

  enable_security_groups = true
  sg_rules = local.example_vpc_sg_rules
}
```

### Files

| Filename                 | Description                                                                 |
|--------------------------|-----------------------------------------------------------------------------|
| `main.tf`                | The main Terraform file of the module used to create a VPCs                 |
| `outputs.tf`             | Output values that are likely needed outside the module                     |
| `var.tf`                 | Variables needed to customize the VPC                                       |