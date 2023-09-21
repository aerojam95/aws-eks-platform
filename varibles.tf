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
# KMS key for CloudWatch log groups for VPC flow logs
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
# CloudTrail
###############################################################################

variable "is_multi_region_trail" {
  type        = bool
  default     = true
  description = "Specifies whether the trail is created in the current region or in all regions"
}

variable "include_global_service_events" {
  type        = bool
  default     = false
  description = "Specifies whether the trail is publishing events from global services such as IAM to the log files"
}

variable "insight_selector" {
  type = list(object({
    insight_type = string
  }))

  description = "Specifies an insight selector for type of insights to log on a trail"
  default     = []
}

variable "event_selector" {
  type = list(object({
    include_management_events = bool
    read_write_type           = string

    data_resource = list(object({
      type   = string
      values = list(string)
    }))
  }))

  description = "Specifies an event selector for enabling data event logging. See: https://www.terraform.io/docs/providers/aws/r/cloudtrail.html for details on this variable"
  default     = []
}

###############################################################################
# CT S3 logging Bucket
###############################################################################

variable "ct_bucket" {
  description = "(Optional, Forces new resource) The name of the bucket. If omitted, Terraform will assign a random, unique name."
  type        = string
  default     = null
}

variable "ct_bucket_prefix" {
  description = "(Optional, Forces new resource) Creates a unique bucket name beginning with the specified prefix. Conflicts with bucket."
  type        = string
  default     = null
}

variable "ct_tags" {
  description = "(Optional) A mapping of tags to assign to the bucket."
  type        = map(string)
  default     = {}
}

variable "ct_logging" {
  description = "Map containing access bucket logging configuration."
  type        = map(string)
  default     = {}
}