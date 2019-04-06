/**
 * Module for creating a VPC
 * Author: Andrew Jarombek
 * Date: 11/4/2018
 */

locals {
  nat_gateway = "${var.enable_nat_gateway ? 1 : 0}"

  # The number of private subnets that use a Nat Gateway
  private_subnet_with_nat = "${var.enable_nat_gateway ? var.private_subnet_count : 0}"
}

#-----------------------
# Existing VPC Resources
#-----------------------

data "aws_availability_zone" "public_subnet_az" {
  count = "${length(var.public_subnet_azs)}"
  name = "${var.public_subnet_azs[count.index]}"
}

data "aws_availability_zone" "private_subnet_az" {
  count = "${length(var.private_subnet_azs)}"
  name = "${var.private_subnet_azs[count.index]}"
}

#----------------------
# General VPC Resources
#----------------------

resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_support = "${var.enable_dns_support}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"

  tags {
    Name = "${var.tag_name}-vpc"
  }
}

resource "aws_internet_gateway" "vpc-igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${var.tag_name}-vpc-internet-gateway"
  }
}

resource "aws_network_acl" "network-acl" {
  vpc_id = "${aws_vpc.vpc.id}"

  egress {
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 0
    to_port = 0
    protocol = "-1"
    rule_no = 10
  }

  ingress {
    action = "allow"
    cidr_block = "0.0.0.0/0"
    from_port = 0
    to_port = 0
    protocol = "-1"
    rule_no = 20
  }

  tags {
    Name = "${var.tag_name}-acl"
  }
}

# https://docs.aws.amazon.com/vpc/latest/userguide/VPC_DHCP_Options.html
resource "aws_vpc_dhcp_options" "vpc-dns-resolver" {
  domain_name_servers = ["AmazonProvidedDNS"]
  domain_name = "ec2.internal"

  tags {
    Name = "${var.tag_name}-dhcp-options"
  }
}

resource "aws_vpc_dhcp_options_association" "vpc-dns-resolver-association" {
  dhcp_options_id = "${aws_vpc_dhcp_options.vpc-dns-resolver.id}"
  vpc_id = "${aws_vpc.vpc.id}"
}

module "vpc-security" {
  source = "../security-group"
  enabled = "${var.enable_security_groups}"

  # Mandatory arguments
  name = "${var.name}-vpc-security"
  tag_name = "${var.tag_name}-vpc-security"
  vpc_id = "${aws_vpc.vpc.id}"

  # Optional arguments
  sg_rules = "${var.sg_rules}"
}

#--------------
# Public Subnet
#--------------

resource "aws_subnet" "public-subnet" {
  count = "${var.public_subnet_count}"

  cidr_block = "${var.public_subnet_count > 1 ?
                    element(var.public_subnet_cidrs, count.index) : var.public_subnet_cidr}"
  vpc_id = "${aws_vpc.vpc.id}"
  availability_zone = "${data.aws_availability_zone.public_subnet_az.*.name[count.index]}"

  tags {
    Name = "${var.public_subnet_custom_names ?
              var.public_subnet_names[count.index] :
              "${var.tag_name}-vpc-public-subnet-${var.private_subnet_count > 1 ? count.index : 0}"}"
  }
}

resource "aws_route_table" "routing-table-public" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "${var.routing_table_cidr}"
    gateway_id = "${aws_internet_gateway.vpc-igw.id}"
  }

  tags {
    Name = "${var.tag_name}-vpc-public-subnet-rt"
  }
}

resource "aws_route_table_association" "routing-table-association-public" {
  count = "${var.public_subnet_count}"

  route_table_id = "${aws_route_table.routing-table-public.id}"
  subnet_id = "${aws_subnet.public-subnet.*.id[count.index]}"
}

#---------------
# Private Subnet
#---------------

resource "aws_subnet" "private-subnet" {
  count = "${var.private_subnet_count}"

  cidr_block = "${var.private_subnet_count > 1 ?
                    element(var.private_subnet_cidrs, count.index) : var.private_subnet_cidr}"
  vpc_id = "${aws_vpc.vpc.id}"
  availability_zone = "${data.aws_availability_zone.private_subnet_az.*.name[count.index]}"

  tags {
    Name = "${var.private_subnet_custom_names ?
              var.private_subnet_names[count.index] :
              "${var.tag_name}-vpc-private-subnet-${var.private_subnet_count > 1 ? count.index : 0}"}"
  }
}

resource "aws_route_table" "routing-table-private" {
  count = "${local.nat_gateway}"

  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "${var.routing_table_cidr}"
    nat_gateway_id = "${aws_nat_gateway.nat-gateway.id}"
  }

  tags {
    Name = "${var.tag_name}-vpc-private-subnet-rt"
  }
}

resource "aws_eip" "nat-elastic-ip" {
  count = "${local.nat_gateway}"

  vpc = true
}

resource "aws_nat_gateway" "nat-gateway" {
  count = "${local.nat_gateway}"

  allocation_id = "${aws_eip.nat-elastic-ip.id}"
  subnet_id = "${aws_subnet.public-subnet.id}"
  depends_on = ["aws_internet_gateway.vpc-igw"]
}

resource "aws_route_table_association" "routing-table-association-private" {
  count = "${local.private_subnet_with_nat}"

  route_table_id = "${aws_route_table.routing-table-private.id}"
  subnet_id = "${aws_subnet.private-subnet.*.id[count.index]}"
}