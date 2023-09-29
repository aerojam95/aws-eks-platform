###############################################################################
# VPC module: https://github.com/terraform-aws-modules/terraform-aws-vpc.git
###############################################################################

module "vpc" {
  #############################################################################
  # VPC  settings
  #############################################################################

  source             = "terraform-aws-modules/vpc/aws"
  version            = "~> 5.1.0"
  manage_default_vpc = true

  #############################################################################
  # VPC
  #############################################################################

  name     = format("${local.name}-vpc")
  cidr     = var.vpc_cidr
  azs      = local.azs
  tags     = local.resource_tags
  vpc_tags = { "Auxillary name" = format("${local.name}-vpc") }

  #############################################################################
  # Publiс Subnets
  #############################################################################

  public_subnets          = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 4)]
  public_route_table_tags = { "Auxillary name" = format("${local.name}-public-route-table") }

  public_subnet_tags = {

    "kubernetes.io/role/elb" = 1

  }

  #############################################################################
  # Public Network ACLs
  #############################################################################

  public_dedicated_network_acl = true
  public_inbound_acl_rules     = var.public_inbound_acl_rules
  public_outbound_acl_rules    = var.public_outbound_acl_rules
  public_acl_tags              = { "Auxillary name" = format("${local.name}-public-nacl") }

  #############################################################################
  # Private Subnets
  #############################################################################

  private_subnets          = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k)]
  private_route_table_tags = { "Auxillary name" = format("${local.name}-private-route-table") }

  private_subnet_tags = {

    "kubernetes.io/role/internal-elb" = 1

  }

  #############################################################################
  # Private Network ACLs
  #############################################################################

  private_dedicated_network_acl = true
  private_inbound_acl_rules     = var.private_inbound_acl_rules
  private_outbound_acl_rules    = var.private_outbound_acl_rules
  private_acl_tags              = { "Auxillary name" = format("${local.name}-private-nacl") }

  #############################################################################
  # Internet Gateway
  #############################################################################

  igw_tags = { "Auxillary name" = format("${local.name}-igw") }

  #############################################################################
  # NAT Gateway
  #############################################################################

  enable_nat_gateway = true
  single_nat_gateway = false
  nat_gateway_tags   = { "Auxillary name" = format("${local.name}-ngw") }
  nat_eip_tags       = { "Auxillary name" = format("${local.name}-neip") }

  #############################################################################
  # Flow Log
  #############################################################################

  enable_flow_log   = true
  vpc_flow_log_tags = { "Name" = format("${local.name}-vpc-flow-logs") }

  #############################################################################
  # Flow Log CloudWatch
  #############################################################################

  create_flow_log_cloudwatch_log_group      = true
  create_flow_log_cloudwatch_iam_role       = true
  flow_log_cloudwatch_log_group_name_prefix = format("/aws/${local.name}/cw-group-vpc-flow-logs/")
  flow_log_cloudwatch_log_group_name_suffix = "vpc-logging"
  flow_log_cloudwatch_log_group_kms_key_id  = module.vpc_flow_log_kms_key.key_arn
}