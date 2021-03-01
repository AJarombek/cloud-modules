# cloud-modules

![Maintained Label](https://img.shields.io/badge/Maintained-Yes-brightgreen?style=for-the-badge)

> Formerly *terraform-modules*

### Overview

Monorepo containing multiple cloud infrastructure modules, packages, and libraries.

**terraform-modules**

Terraform modules to help create reusable infrastructure.  Utilized by the
[global-aws-infrastructure](https://github.com/AJarombek/global-aws-infrastructure),
[saints-xctf-infrastructure](https://github.com/AJarombek/saints-xctf-infrastructure), and 
[jarombek-com-infrastructure](https://github.com/AJarombek/jarombek-com-infrastructure) repositories.

### Versions

> v0.1.0 Initial Release of `security-group` and `vpc` modules

> v0.1.1 Changed naming conventions for the `security-group` and `vpc` modules

> v0.1.3 Fixed security groups in the `vpc` module

> v0.1.4 Upgraded to Terraform 0.12

> v0.1.5 Fix Terraform 0.12 related bugs, make custom subnet names mandatory

> v0.1.6 Refactor the security-group module logic around enable/disable

> v0.1.7 Refactor the vpc module logic for Terraform 0.12

> v0.1.8 Initial Release of the `acm-certificate` module

> v0.1.9 Ability to disable the entire `acm-certificate` module or just the `aws_acm_certificate_validation` resource.

> v0.1.10 Choice to map public IP addresses to instances within a public subnet for the `vpc` module.

> v0.1.11 Custom tags for subnets in the `vpc` module.

> v0.1.12 `vpc` module subnet ID output.

> v0.2.0 Turn repo into monorepo containing multiple modules & libraries.

> v0.2.1 Initialize the aws_test_functions Python package for helping test AWS infrastructure with `boto3`.  Add the 
> `api-gateway-endpoint` Terraform module.

> v0.2.2 Fix for the naming of the aws_test_functions Python package.

> v0.2.3 Additional API Gateway methods in aws_test_functions.

> v0.2.4 Added Kubernetes Go module.

> v0.2.5 Kubernetes module name change.

> v0.2.6 Initial release of the `lambda` Terraform module.

> v0.2.7 Lambda authorizer configuration for API Gateway endpoint Terraform module.

> v0.2.8 API Gateway endpoint allows for multiple request templates.

> v0.2.9 Kubernetes module function for checking whether a Deployment is error free.

### Directories

| Directory Name              | Description                                                                 |
|-----------------------------|-----------------------------------------------------------------------------|
| `aws-test-functions`        | Boto3 reusable Python functions for testing AWS infrastructure.             |
| `kubernetes-test-functions` | Kubernetes client reusable Go functions for testing K8s infrastructure.     |
| `terraform-modules`         | Reusable Terraform modules for building AWS infrastructure.                 |