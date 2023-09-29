###############################################################################
# General variables
###############################################################################

region  = ""
project = "container-platform"
name    = "container-platform"


###############################################################################
# VPC
###############################################################################

vpc_cidr = "10.0.0.0/16"

###############################################################################
# Public Network ACLs
###############################################################################

public_inbound_acl_rules = [
  {
    rule_number = 100
    rule_action = "allow"
    from_port   = 0
    to_port     = 65535
    protocol    = "-1"
    cidr_block  = "0.0.0.0/0"
  }
]

public_outbound_acl_rules = [
  {
    rule_number = 100
    rule_action = "allow"
    from_port   = 0
    to_port     = 65535
    protocol    = "-1"
    cidr_block  = "0.0.0.0/0"
  }
]

###############################################################################
# Private Network ACLs
###############################################################################

private_inbound_acl_rules = [
  {
    rule_number = 100
    rule_action = "allow"
    from_port   = 0
    to_port     = 65535
    protocol    = "-1"
    cidr_block  = "0.0.0.0/0"
  }
]

private_outbound_acl_rules = [
  {
    rule_number = 100
    rule_action = "allow"
    from_port   = 0
    to_port     = 65535
    protocol    = "-1"
    cidr_block  = "0.0.0.0/0"
  }
]

###############################################################################
# VPC endpoints SG
###############################################################################

###############################################################################
# Egress
###############################################################################

egress_with_cidr_blocks = [
  {
    rule        = "https-443-tcp"
    description = "All egress HTTPS"
    cidr_blocks = "0.0.0.0/0"
  },
]

###############################################################################
# CloudTrail
###############################################################################

is_multi_region_trail         = false
include_global_service_events = true

###############################################################################
# EKS Cluster
###############################################################################

cluster_version = "1.27"

###############################################################################
# EKS Addons
###############################################################################

cluster_addons = {
  coredns    = {}
  kube-proxy = {}
  vpc-cni    = {}
}

###############################################################################
# EKS Managed Node Group
###############################################################################

eks_managed_node_groups = {
  private-eks-node = {
    iam_role_additional_policies = {
      AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    }
    instance_types = ["m5.large"]
    min_size       = 1
    max_size       = 5
    desired_size   = 3
  }
}