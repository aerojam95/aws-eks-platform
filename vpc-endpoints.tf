###############################################################################
# VPC endpoints module: https://github.com/terraform-aws-modules/terraform-aws-vpc.git
###############################################################################

module "vpc_endpoints" {
  #############################################################################
  # VPC endpoints settings
  #############################################################################

  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "~> 5.1.0"

  #############################################################################
  # VPC endpoints 
  #############################################################################

  vpc_id             = module.vpc.vpc_id
  security_group_ids = [module.vpc_endpoints_sg.security_group_id]
  subnet_ids         = module.vpc.private_subnets
  tags               = local.resource_tags

  endpoints = merge({
    s3 = {
      service         = "s3"
      service_type    = "Gateway"
      route_table_ids = module.vpc.private_route_table_ids
      tags = {
        Name = "${local.name}-vpc-s3"
      }
    }
    },
    { for service in toset(["autoscaling", "ecr.api", "ecr.dkr", "ec2", "ec2messages", "elasticloadbalancing", "sts", "kms", "logs", "ssm", "ssmmessages"]) :
      replace(service, ".", "_") =>
      {
        service             = service
        subnet_ids          = module.vpc.private_subnets
        private_dns_enabled = true
        tags                = { Name = "${local.name}-${service}" }
      }
  })

}

###############################################################################
# SG module: https://github.com/terraform-aws-modules/terraform-aws-security-group.git 
###############################################################################

module "vpc_endpoints_sg" {
  #############################################################################
  # Security group settings
  #############################################################################

  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.1.0"

  #############################################################################
  # Security group
  #############################################################################

  name        = "${local.name}-vpc-endpoints-sg"
  description = "Security group for VPC endpoint access"
  vpc_id      = module.vpc.vpc_id
  tags        = local.resource_tags

  #############################################################################
  # Ingress
  #############################################################################

  ingress_with_cidr_blocks = [
    {
      rule        = "https-443-tcp"
      description = "VPC CIDR HTTPS"
      cidr_blocks = join(",", module.vpc.private_subnets_cidr_blocks)
    },
  ]

  #############################################################################
  # Egress
  #############################################################################

  egress_with_cidr_blocks = var.egress_with_cidr_blocks
}