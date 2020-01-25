/**
 * Varaibles for creating an ACM Certificate
 * Author: Andrew Jarombek
 * Date: 1/25/2020
 */

#-----------------
# Naming Resources
#-----------------

variable "name" {
  description = "Name to use as a prefix for different resources"
}

variable "tag_name" {
  description = "Name to use for the Name property in the Tag objects"
}

variable "tag_application" {
  description = "Application the resource belongs to.  Used in the Tag objects."
}

variable "tag_environment" {
  description = "Environment the resource is deployed in.  Used in the Tag objects."
}

#------------------------------
# aws_acm_certificate Variables
#------------------------------

variable "route53_zone_name" {
  description = "Route53 zone name for the ACM certificate"
  type = string
}

variable "route53_zone_private" {
  description = "Whether or not the Route53 zone for the ACM certificate is private"
  default = false
}

variable "acm_domain_name" {
  description = "Domain name for the ACM certificate"
  type = string
}