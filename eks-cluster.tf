
################################################################################
# Cluster
################################################################################

#tfsec:ignore:aws-eks-enable-control-plane-logging
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.13"

  cluster_name    = local.name
  cluster_version = var.cluster_version

  # EKS Addons
  cluster_addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni    = {}
  }

  vpc_id                              = data.aws_vpc.eks_vpc.id
  subnet_ids                          = data.aws_subnets.private.ids

  cluster_security_group_additional_rules = {
    ingress_nodes_kube_api = {
      description                = "API access from VPC"
      protocol                   = "tcp"
      from_port                  = 443
      to_port                    = 443
      type                       = "ingress"
      cidr_blocks                = [data.aws_vpc.eks_vpc.cidr_block]
    }    
  }

  eks_managed_node_groups = {
    private-eks-node = {
      instance_types = ["m5.large"]

      min_size     = 1
      max_size     = 5
      desired_size = 3
    }
  }

  tags = local.tags
}
