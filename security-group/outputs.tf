/**
 * Output variables for a created Security Group
 * Author: Andrew Jarombek
 * Date: 2/12/2019
 */

output "security_group_id" {
  value = "${aws_security_group.security.id}"
}