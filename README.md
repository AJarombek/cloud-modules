# terraform-modules

### Overview

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

### Directories

| Directory Name    | Description                                                                 |
|-------------------|-----------------------------------------------------------------------------|
| `security-group`  | Infrastructure for a configurable security group.                           |
| `vpc`             | Infrastructure for a configurable virtual private cloud.                    |