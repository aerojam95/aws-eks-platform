###############################################################################
# General variables
###############################################################################

variable "region" {
  type    = string
  default = "eu-west-2"
}

variable "project" {
  description = "Project tag in which the AWS infrastructure belongs"
  type        = string
  default     = ""
}

variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

###############################################################################
# VPC
###############################################################################

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

###############################################################################
# Public subnets
###############################################################################

variable "public_inbound_acl_rules" {
  description = "Public subnets inbound network ACLs"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 80
      to_port     = 80
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "public_outbound_acl_rules" {
  description = "Public subnets outbound network ACLs"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 80
      to_port     = 80
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

###############################################################################
# Private subnets
###############################################################################


variable "private_inbound_acl_rules" {
  description = "Private subnets inbound network ACLs"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 80
      to_port     = 80
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

variable "private_outbound_acl_rules" {
  description = "Private subnets outbound network ACLs"
  type        = list(map(string))
  default = [
    {
      rule_number = 100
      rule_action = "allow"
      from_port   = 80
      to_port     = 80
      protocol    = "-1"
      cidr_block  = "0.0.0.0/0"
    },
  ]
}

###############################################################################
# KMS key
###############################################################################

variable "key_statements" {
  description = "A map of IAM policy [statements](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document#statement) for custom permission usage"
  type        = any
  default     = {}
}

###############################################################################
# VPC endpoints SG
###############################################################################

###############################################################################
# Ingress
###############################################################################

variable "ingress_with_cidr_blocks" {
  description = "List of ingress rules to create where 'cidr_blocks' is used"
  type        = list(map(string))
  default = [
    {
      rule        = "all-all"
      description = "all ingress HTTPS"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

###############################################################################
# Egress
###############################################################################

variable "egress_with_cidr_blocks" {
  description = "List of egress rules to create where 'cidr_blocks' is used"
  type        = list(map(string))
  default = [
    {
      rule        = "all-all"
      description = "All egress HTTPS"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

###############################################################################
# VPC endpoints
###############################################################################

###############################################################################
# Endpoints
###############################################################################

variable "endpoints" {
  description = "A map of interface and/or gateway endpoints containing their properties and configurations"
  type        = any
  default     = {}
}

###############################################################################
# AWS cloud map
###############################################################################

###############################################################################
# Namespace
###############################################################################

variable "namespace_name" {
  description = "Name of AWS cloud map namespace"
  type        = string
  default     = ""
}