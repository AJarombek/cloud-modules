/**
 * Varaibles for creating a Security Group
 * Author: Andrew Jarombek
 * Date: 2/11/2019
 */

# Needed since terraform modules do not support the 'count' property
variable "enabled" {
  description = "Whether or not the security group should be created"
  default     = true
}

#-----------------
# Naming Variables
#-----------------

variable "name" {
  description = "Name to use as a prefix for different resources"
}

variable "tags" {
  description = "Map of tags for the security group"
  type        = map(any)
  default     = {}
}

#-----------------------------
# aws_security_group Variables
#-----------------------------

variable "vpc_id" {
  description = "VPC identifier for the security group"
}

variable "description" {
  description = "Information about the security group"
  type        = string
  default     = "Security Group"
}

variable "sg_rules" {
  description = "A list of security group rules"
  type        = list(any)
  default     = []
}