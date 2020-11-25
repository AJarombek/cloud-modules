### Overview

Module for setting up a Security Group and all the appropriate rules.

### Use Case

```hcl-terraform
module "security-group" {
  source = "github.com/ajarombek/cloud-modules//terraform-modules/security-group?ref=v0.1.6"

  # Mandatory arguments
  name = "example-sg"
  tag_name = "example-sg"
  vpc_id = data.existing-vpc.vpc_id

  # Optional arguments
  sg_rules = local.sg_rules
  description = "example sg module"
}
```

### Files

| Filename                 | Description                                                                 |
|--------------------------|-----------------------------------------------------------------------------|
| `main.tf`                | The main Terraform file of the module used to create a Security Groups      |
| `outputs.tf`             | Output values that are likely needed outside the module                     |
| `var.tf`                 | Variables needed to customize the Security Group                            |