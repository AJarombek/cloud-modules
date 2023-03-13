/**
 * Varaibles for creating an ACM Certificate
 * Author: Andrew Jarombek
 * Date: 1/25/2020
 */

variable "cert_validation_enabled" {
  description = "Whether or not the certificate validation resource is enabled."
  type        = bool
  default     = true
}

#-----------------
# Naming Resources
#-----------------

variable "name" {
  description = "Name to use as a prefix for different resources."
  type        = string
}

variable "tags" {
  description = "Map of tags for the security group"
  type        = map(any)
  default     = {}
}

#------------------------------
# aws_acm_certificate Variables
#------------------------------

variable "route53_zone_name" {
  description = "Route53 zone name for the ACM certificate."
  type        = string
}

variable "route53_zone_private" {
  description = "Whether or not the Route53 zone for the ACM certificate is private."
  type        = bool
  default     = false
}

variable "acm_domain_name" {
  description = "Domain name for the ACM certificate."
  type        = string
}