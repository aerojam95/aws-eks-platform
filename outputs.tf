###############################################################################
# General variables
###############################################################################

output "region" {
  description = "AWS region in which the AWS infrastructure has been deployed"
  value       = var.region
}

###############################################################################
# VPC
###############################################################################

output "azs" {
  description = "A list of availability zones specified as argument to this module"
  value       = local.azs
}

output "vpc_name" {
  description = "The name of the VPC specified as argument to this module"
  value       = var.name
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = try(module.vpc.vpc_id, null)
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = try(module.vpc.vpc_arn, null)
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = try(module.vpc.vpc_cidr_block, null)
}

output "vpc_main_route_table_id" {
  description = "The ID of the main route table associated with this VPC"
  value       = try(module.vpc.vpc_main_route_table_id, null)
}

output "vpc_owner_id" {
  description = "The ID of the AWS account that owns the VPC"
  value       = try(module.vpc.vpc_owner_id, null)
}

###############################################################################
# Internet Gateway
###############################################################################

output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = try(module.vpc.igw_id, null)
}

output "igw_arn" {
  description = "The ARN of the Internet Gateway"
  value       = try(module.vpc.igw_arn, null)
}

###############################################################################
# Publiс Subnets
###############################################################################

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = try(module.vpc.public_subnets, null)
}

output "public_subnet_arns" {
  description = "List of ARNs of public subnets"
  value       = try(module.vpc.public_subnet_arns, null)
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = try(module.vpc.public_subnets_cidr_blocks, null)
}

output "public_route_table_ids" {
  description = "List of IDs of public route tables"
  value       = try(module.vpc.public_route_table_ids, null)
}

output "public_internet_gateway_route_id" {
  description = "ID of the internet gateway route"
  value       = try(module.vpc.public_internet_gateway_route_id, null)
}

output "public_route_table_association_ids" {
  description = "List of IDs of the public route table association"
  value       = try(module.vpc.public_route_table_association_ids, null)
}

output "public_network_acl_id" {
  description = "ID of the public network ACL"
  value       = try(module.vpc.public_network_acl_id, null)
}

output "public_network_acl_arn" {
  description = "ARN of the public network ACL"
  value       = try(module.vpc.public_network_acl_arn, null)
}

###############################################################################
# Private Subnets
###############################################################################

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = try(module.vpc.private_subnets, null)
}

output "private_subnet_arns" {
  description = "List of ARNs of private subnets"
  value       = try(module.vpc.private_subnet_arns, null)
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = try(module.vpc.private_subnets_cidr_blocks, null)
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = try(module.vpc.private_route_table_ids, null)
}

output "private_nat_gateway_route_ids" {
  description = "List of IDs of the private nat gateway route"
  value       = try(module.vpc.private_nat_gateway_route_ids, null)
}

output "private_route_table_association_ids" {
  description = "List of IDs of the private route table association"
  value       = try(module.vpc.private_route_table_association_ids, null)
}

output "private_network_acl_id" {
  description = "ID of the private network ACL"
  value       = try(module.vpc.private_network_acl_id, null)
}

output "private_network_acl_arn" {
  description = "ARN of the private network ACL"
  value       = try(module.vpc.private_network_acl_arn, null)
}

###############################################################################
# NAT Gateway
###############################################################################

output "nat_ids" {
  description = "List of allocation ID of Elastic IPs created for AWS NAT Gateway"
  value       = try(module.vpc.nat_ids, null)
}

output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = try(module.vpc.nat_public_ips, null)
}

output "natgw_ids" {
  description = "List of NAT Gateway IDs"
  value       = try(module.vpc.natgw_ids, null)
}

###############################################################################
# VPC Flow Log
###############################################################################

output "vpc_flow_log_id" {
  description = "The ID of the Flow Log resource"
  value       = try(module.vpc.vpc_flow_log_id, null)
}

output "vpc_flow_log_destination_arn" {
  description = "The ARN of the destination for VPC Flow Logs"
  value       = try(module.vpc.vpc_flow_log_destination_arn, null)
}

output "vpc_flow_log_cloudwatch_iam_role_arn" {
  description = "The ARN of the IAM role used when pushing logs to Cloudwatch log group"
  value       = try(module.vpc.vpc_flow_log_cloudwatch_iam_role_arn, null)
}

###############################################################################
#  KMS key for CloudWatch log groups for VPC flow logs
###############################################################################

output "vpc_flow_log_key_arn" {
  description = "The Amazon Resource Name (ARN) of the key"
  value       = try(module.vpc_flow_log_kms_key.key_arn, null)
}

output "vpc_flow_log_key_id" {
  description = "The globally unique identifier for the key"
  value       = try(module.vpc_flow_log_kms_key.key_id, null)
}

output "vpc_flow_log_key_policy" {
  description = "The IAM resource policy set on the key"
  value       = try(module.vpc_flow_log_kms_key.key_policy, null)
}

###############################################################################
# Alias for KMS key for CloudWatch log groups for VPC flow logs
###############################################################################

output "vpc_flow_log_key_aliases" {
  description = "A map of aliases created and their attributes"
  value       = module.kms_key.aliases
}

###############################################################################
# VPC endpoints SG
###############################################################################
output "security_group_arn" {
  description = "The ARN of the security group"
  value       = try(module.vpc_endpoints_sg.security_group_arn, null)
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = try(module.vpc_endpoints_sg.security_group_id, null)
}

output "security_group_vpc_id" {
  description = "The VPC ID"
  value       = try(module.vpc_endpoints_sg.security_group_vpc_id, null)
}

output "security_group_owner_id" {
  description = "The owner ID"
  value       = try(module.vpc_endpoints_sg.security_group_owner_id, null)
}

output "security_group_name" {
  description = "The name of the security group"
  value       = try(module.vpc_endpoints_sg.security_group_name, null)
}

###############################################################################
# VPC endpoints
###############################################################################

output "endpoints" {
  description = "Array containing the full resource object and attributes for all endpoints created"
  value       = try(module.vpc_endpoints.endpoints, null)
}

###############################################################################
#  AWS Cloud Map
###############################################################################

###############################################################################
#  Namespace
###############################################################################

output "namespace_id" {
  description = "The ID of the cloud map namespace"
  value       = try(module.namespace.namespace_id, null)
}

output "namespace_arn" {
  description = "The ARN of the cloud map namespace"
  value       = try(module.namespace.namespace_arn, null)
}

output "namespace_hosted_zone" {
  description = "The ID for the hosted zone that AWS Route 53 creates when you create a namespace"
  value       = try(module.namespace.namespace_hosted_zone, null)
}

output "namespace_tags" {
  description = "The tags of the cloud map namespace resource tags"
  value       = try(module.namespace.namespace_tags, null)
}

output "aws_cloud_map_iam_role_arn" {
  description = "The ARN of the IAM role used when pushing logs to Cloudwatch log group"
  value       = try(module.namespace.aws_cloud_map_iam_role_arn, null)
}

###############################################################################
#  IAM role for AWS Cloud Map Namespace
###############################################################################

output "admin_iam_role_arn" {
  description = "ARN of admin IAM role"
  value       = try(aws_iam_role.aws_cloud_map_iam_role.arn, "")
}

output "admin_iam_role_name" {
  description = "Name of admin IAM role"
  value       = try(aws_iam_role.aws_cloud_map_iam_role.name, "")
}