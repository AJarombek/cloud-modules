/**
 * Output variables for a created Security Group
 * Author: Andrew Jarombek
 * Date: 2/12/2019
 */

output "security_group_id" {
  # There will always be 0 or 1 security groups in the output
  value = aws_security_group.security.*.id
}