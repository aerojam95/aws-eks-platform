###############################################################################
# EKS Cluster: https://github.com/terraform-aws-modules/terraform-aws-eks.git
###############################################################################

#tfsec:ignore:aws-eks-enable-control-plane-logging
module "eks" {

  #############################################################################
  # EKS cluster settings
  #############################################################################

  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.16.0"

  #############################################################################
  # EKS cluster
  #############################################################################

  tags                     = local.resource_tags
  cluster_name             = format("${local.name}-eks-cluster")
  cluster_version          = var.cluster_version
  control_plane_subnet_ids = module.vpc.private_subnets
  subnet_ids               = module.vpc.private_subnets
  cluster_tags             = { "Name" = format("${local.name}-eks-cluster") }

  #############################################################################
  # KMS key for EKS cluster encryption
  #############################################################################

  kms_key_owners         = [data.aws_caller_identity.current.arn]
  kms_key_administrators = [data.aws_caller_identity.current.arn]
  kms_key_users          = [data.aws_caller_identity.current.arn]

  ###############################################################################
  # EKS Cluster CloudWatch Log Group
  ###############################################################################

  cloudwatch_log_group_kms_key_id = module.eks_cluster_logs_kms_key.key_arn

  ###############################################################################
  # EKS Cluster Security Group
  ###############################################################################

  vpc_id                      = module.vpc.vpc_id
  cluster_security_group_name = format("${local.name}-eks-cluster-sg")
  cluster_security_group_tags = { "Name" = format("${local.name}-eks-cluster-sg") }

  cluster_security_group_additional_rules = {
    ingress_nodes_kube_api = {
      description = "API access from VPC"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "ingress"
      cidr_blocks = [module.vpc.vpc_cidr_block]
    }
  }

  ###############################################################################
  # EKS Cluster Node Security Group
  ###############################################################################

  node_security_group_name = format("${local.name}-eks-cluster-node-sg")
  node_security_group_tags = { "Name" = format("${local.name}-eks-cluster-node-sg") }

  ###############################################################################
  # EKS Cluster IAM Role
  ###############################################################################

  iam_role_name                  = format("${local.name}-eks-cluster-role")
  iam_role_tags                  = { "Name" = format("${local.name}-eks-cluster-iam-role") }
  cluster_encryption_policy_name = format("${local.name}-eks-cluster-encryption-policy")
  cluster_encryption_policy_tags = { "Name" = format("${local.name}-eks-cluster-encryption-policy") }

  ###############################################################################
  # EKS Addons
  ###############################################################################

  cluster_addons = var.cluster_addons

  ###############################################################################
  # EKS Managed Node Group
  ###############################################################################

  eks_managed_node_groups = var.eks_managed_node_groups
}

# module "eks_blueprints_addons" {
#   # tflint-ignore: terraform_module_pinned_source
#   source = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/kubernetes-addons?ref=v4.32.1"
#   #source = "https://registry.terraform.io/modules/aws-ia/eks-blueprints-addons/aws"
#   #source = "https://github.com/aws-ia/terraform-aws-eks-blueprints/tree/main/modules/kubernetes-addons?ref=main" #
#   #source = "aws-ia/eks-blueprints-addons/aws"
#   #version = "1.3.0"

#   eks_cluster_id        = module.eks.cluster_name
#   eks_cluster_endpoint  = module.eks.cluster_endpoint
#   eks_cluster_version   = module.eks.cluster_version
#   eks_oidc_provider     = module.eks.oidc_provider
#   eks_oidc_provider_arn = module.eks.oidc_provider_arn

#   # Add-ons
#   enable_aws_load_balancer_controller  = true

#   tags = local.tags
# }