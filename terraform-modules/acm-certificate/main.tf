/**
 * Module for creating an ACM Certificate
 * Author: Andrew Jarombek
 * Date: 1/25/2020
 */

locals {
  cert_validation_count = var.cert_validation_enabled ? 1 : 0
}

#-------------------
# Existing Resources
#-------------------

/* A Route53 zone is needed for the certificate validation records */
data "aws_route53_zone" "zone" {
  name = var.route53_zone_name
  private_zone = var.route53_zone_private
}

#--------------------------
# New AWS Resources for ACM
#--------------------------

resource "aws_acm_certificate" "certificate" {
  domain_name = var.acm_domain_name
  validation_method = "DNS"

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "validation-record" {
  for_each = {
    for dvo in aws_acm_certificate.certificate.domain_validation_options: dvo.domain_name => {
      name = dvo.resource_record_name
      record = dvo.resource_record_value
      type = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name = each.value.name
  type = each.value.type
  zone_id = data.aws_route53_zone.zone.id
  records = [each.value.record]
  ttl = 60
}

/* Request a DNS validation certificate */
resource "aws_acm_certificate_validation" "cert-validation" {
  count = local.cert_validation_count

  certificate_arn = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.validation-record: record.fqdn]
}