/**
 * Output variables for a created ACM certificate.
 * Author: Andrew Jarombek
 * Date: 1/25/2020
 */

output "acm_id" {
  value = aws_acm_certificate.certificate[0].id
}

output "acm_arn" {
  value = aws_acm_certificate.certificate[0].arn
}