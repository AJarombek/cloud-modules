# cloud-modules

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

### Directories

| Directory Name              | Description                                                                 |
|-----------------------------|-----------------------------------------------------------------------------|
| `aws-test-functions`        | Boto3 reusable Python functions for testing AWS infrastructure.             |
| `kubernetes-test-functions` | Kubernetes client reusable Go functions for testing K8s infrastructure.     |
| `terraform-modules`         | Reusable Terraform modules for building AWS infrastructure.                 |