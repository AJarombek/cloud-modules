### Overview

Terraform modules to help create reusable infrastructure.  Utilized by the
[global-aws-infrastructure](https://github.com/AJarombek/global-aws-infrastructure),
[saints-xctf-infrastructure](https://github.com/AJarombek/saints-xctf-infrastructure), and 
[jarombek-com-infrastructure](https://github.com/AJarombek/jarombek-com-infrastructure) repositories.

### Directories

| Directory Name         | Description                                                                 |
|------------------------|-----------------------------------------------------------------------------|
| `acm-certificate`      | Infrastructure for a DNS validated ACM certificate.                         |
| `api-gateway-endpoint` | Infrastructure for an endpoint in an API Gateway REST API.                  |
| `security-group`       | Infrastructure for a configurable security group.                           |
| `vpc`                  | Infrastructure for a configurable virtual private cloud.                    |