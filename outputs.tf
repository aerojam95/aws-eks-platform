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
  value       = try(module.vpc_flow_log_kms_key.aliases, null)
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
# CloudTrail
###############################################################################

output "cloudtrail_id" {
  description = "The name of the trail"
  value       = try(module.cloudtrail.cloudtrail_id, null)
}

output "cloudtrail_home_region" {
  description = "The region in which the trail was created"
  value       = try(module.cloudtrail.cloudtrail_home_region, null)
}

output "cloudtrail_arn" {
  description = "The Amazon Resource Name of the trail"
  value       = try(module.cloudtrail.cloudtrail_arn, null)
}

output "cloudtrail_bucket_domain_name" {
  description = "FQDN of the CloudTral S3 bucket"
  value       = try(module.cloudtrail.bucket_domain_name, null)
}

###############################################################################
#  IAM role for CT
###############################################################################

output "aws_ct_iam_role_iam_role_arn" {
  description = "ARN of AWS CloudTrail IAM role"
  value       = try(aws_iam_role.aws_ct_iam_role.arn, "")
}

output "aws_ct_iam_role_iam_role_name" {
  description = "Name of AWS CloudTrail IAM role"
  value       = try(aws_iam_role.aws_ct_iam_role.name, "")
}

###############################################################################
# CT S3 logging Bucket
###############################################################################

output "ct_s3_bucket_id" {
  description = "The name of the bucket."
  value       = try(module.s3_bucket_ct_logs.s3_bucket_id, "")
}

output "ct_s3_bucket_arn" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
  value       = try(module.s3_bucket_ct_logs.s3_bucket_arn, "")
}

output "ct_s3_bucket_lifecycle_configuration_rules" {
  description = "The lifecycle rules of the bucket, if the bucket is configured with lifecycle rules. If not, this will be an empty string."
  value       = try(module.s3_bucket_ct_logs.s3_bucket_lifecycle_configuration_rules, "")
}

output "ct_s3_bucket_policy" {
  description = "The policy of the bucket, if the bucket is configured with a policy. If not, this will be an empty string."
  value       = try(module.s3_bucket_ct_logs.s3_bucket_policy, "")
}

###############################################################################
# CT S3 logs KMS key
###############################################################################

output "ct_logs_s3_bucket_kms_key_arn" {
  description = "The Amazon Resource Name (ARN) of the key"
  value       = try(module.ct_logs_s3_bucket_kms_key.key_arn, null)
}

output "ct_logs_s3_bucket_kms_key_id" {
  description = "The globally unique identifier for the key"
  value       = try(module.ct_logs_s3_bucket_kms_key.key_id, null)
}

output "ct_logs_s3_bucket_kms_key_policy" {
  description = "The IAM resource policy set on the key"
  value       = try(module.ct_logs_s3_bucket_kms_key.key_policy, null)
}

###############################################################################
# Alias for KMS key for CloudWatch log groups for CT S3 logs
###############################################################################

output "ct_logs_s3_bucket_kms_aliases" {
  description = "A map of aliases created and their attributes"
  value       = module.ct_logs_s3_bucket_kms_key.aliases
}

###############################################################################
# CT CW logs KMS key
###############################################################################

output "ct_logs_cw_logs_kms_key_arn" {
  description = "The Amazon Resource Name (ARN) of the key"
  value       = try(module.ct_logs_cw_logs_kms_key.key_arn, null)
}

output "ct_logs_cw_logs_bucket_kms_key_id" {
  description = "The globally unique identifier for the key"
  value       = try(module.ct_logs_cw_logs_kms_key.key_id, null)
}

output "ct_logs_cw_logs_bucket_kms_key_policy" {
  description = "The IAM resource policy set on the key"
  value       = try(module.ct_logs_cw_logs_kms_key.key_policy, null)
}

###############################################################################
# Alias for KMS key for CloudWatch log groups for CT CW logs
###############################################################################

output "ct_logs_cw_logs_kms_aliases" {
  description = "A map of aliases created and their attributes"
  value       = module.ct_logs_cw_logs_kms_key.aliases
}

################################################################################
# EKS Cluster
################################################################################

output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = try(module.eks.cluster_arn, null)
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = try(module.eks.cluster_certificate_authority_data, null)
}

output "cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value       = try(module.eks.cluster_endpoint, null)
}

output "cluster_id" {
  description = "The ID of the EKS cluster. Note: currently a value is returned only for local EKS clusters created on Outposts"
  value       = try(module.eks.cluster_id, "")
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = try(module.eks.cluster_name, "")
}

output "cluster_version" {
  description = "The Kubernetes version for the cluster"
  value       = try(module.eks.cluster_version, null)
}

output "cluster_platform_version" {
  description = "Platform version for the cluster"
  value       = try(module.eks.cluster_platform_version, null)
}

output "cluster_status" {
  description = "Status of the EKS cluster. One of `CREATING`, `ACTIVE`, `DELETING`, `FAILED`"
  value       = try(module.eks.cluster_status, null)
}

output "cluster_primary_security_group_id" {
  description = "Cluster security group that was created by Amazon EKS for the cluster. Managed node groups use this security group for control-plane-to-data-plane communication. Referred to as 'Cluster security group' in the EKS console"
  value       = try(module.eks.cluster_primary_security_group_id, null)
}

################################################################################
# KMS Key
################################################################################

output "kms_key_arn" {
  description = "The Amazon Resource Name (ARN) of the key"
  value       = module.eks.kms_key_arn
}

output "kms_key_id" {
  description = "The globally unique identifier for the key"
  value       = module.eks.kms_key_id
}

output "kms_key_policy" {
  description = "The IAM resource policy set on the key"
  value       = module.eks.kms_key_policy
}

################################################################################
# Cluster Security Group
################################################################################

output "cluster_security_group_arn" {
  description = "Amazon Resource Name (ARN) of the cluster security group"
  value       = try(module.eks.cluster_security_group_arn, null)
}

output "cluster_security_group_id" {
  description = "ID of the cluster security group"
  value       = try(module.eks.cluster_security_group_id, null)
}

################################################################################
# Node Security Group
################################################################################

output "node_security_group_arn" {
  description = "Amazon Resource Name (ARN) of the node shared security group"
  value       = try(module.eks.node_security_group_arn, null)
}

output "node_security_group_id" {
  description = "ID of the node shared security group"
  value       = try(module.eks.node_security_group_id, null)
}

################################################################################
# IAM Role
################################################################################

output "cluster_iam_role_name" {
  description = "IAM role name of the EKS cluster"
  value       = try(module.eks.cluster_iam_role_name, null)
}

output "cluster_iam_role_arn" {
  description = "IAM role ARN of the EKS cluster"
  value       = try(module.eks.cluster_iam_role_arn, null)
}

output "cluster_iam_role_unique_id" {
  description = "Stable and unique string identifying the IAM role"
  value       = try(module.eks.cluster_iam_role_unqiue_id, null)
}

################################################################################
# EKS Addons
################################################################################

output "cluster_addons" {
  description = "Map of attribute maps for all EKS cluster addons enabled"
  value       = try(module.eks.cluster_addons, null)
}


################################################################################
# CloudWatch Log Group
################################################################################

output "cloudwatch_log_group_name" {
  description = "Name of cloudwatch log group created"
  value       = try(module.eks.cloudwatch_log_group_name, null)
}

output "cloudwatch_log_group_arn" {
  description = "Arn of cloudwatch log group created"
  value       = try(module.eks.cloudwatch_log_group_arn, null)
}

################################################################################
# EKS Managed Node Group
################################################################################

output "eks_managed_node_groups" {
  description = "Map of attribute maps for all EKS managed node groups created"
  value       = module.eks.eks_managed_node_groups
}

################################################################################
# EKS Cluster additional
################################################################################

output "configure_kubectl" {
  description = "Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig"
  value       = "aws eks --region ${local.region} update-kubeconfig --name ${module.eks.cluster_name}"
}


###############################################################################
# EKS Cluster logs KMS key
###############################################################################

output "eks_cluster_logs_kms_key_arn" {
  description = "The Amazon Resource Name (ARN) of the key"
  value       = try(module.eks_cluster_logs_kms_key.key_arn, null)
}

output "eks_cluster_logs_kms_key_id" {
  description = "The globally unique identifier for the key"
  value       = try(module.eks_cluster_logs_kms_key.key_id, null)
}

###############################################################################
# Alias for KMS key for CloudWatch log groups for EKS Cluster logs
###############################################################################

output "eks_cluster_logs_kms_aliases" {
  description = "A map of aliases created and their attributes"
  value       = module.eks_cluster_logs_kms_key.aliases
}

###############################################################################
#  IAM role for admin
###############################################################################

output "admin_iam_role_arn" {
  description = "ARN of admin IAM role"
  value       = try(aws_iam_role.admin_iam_role.arn, "")
}

output "admin_iam_role_name" {
  description = "Name of admin IAM role"
  value       = try(aws_iam_role.admin_iam_role.name, "")
}