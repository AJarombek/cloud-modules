/**
 * Module for creating an ACM Certificate
 * Author: Andrew Jarombek
 * Date: 1/25/2020
 */

locals {
  count = var.enabled ? 1 : 0
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
  count = local.count

  domain_name = var.acm_domain_name
  validation_method = "DNS"

  tags = {
    Name = var.tag_name
    Environment = var.tag_environment
    Application = var.tag_application
  }

  lifecycle {
    create_before_destroy = true
  }
}

/* Create a validation record used for certificate validation through DNS */
resource "aws_route53_record" "certificate-validation-record" {
  count = local.count

  name = aws_acm_certificate.certificate[0].domain_validation_options[0].resource_record_name
  type = aws_acm_certificate.certificate[0].domain_validation_options[0].resource_record_type
  zone_id = data.aws_route53_zone.zone.id
  records = [aws_acm_certificate.certificate[0].domain_validation_options[0].resource_record_value]
  ttl = 60
}

/* Request a DNS validation certificate */
resource "aws_acm_certificate_validation" "cert-validation" {
  count = local.cert_validation_count

  certificate_arn = aws_acm_certificate.certificate[0].arn
  validation_record_fqdns = [aws_route53_record.certificate-validation-record[0].fqdn]
}