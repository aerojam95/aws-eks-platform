###############################################################################
# Providers
###############################################################################

# AWS provider configuration
provider "aws" {
  region = local.region
}

# Kubernetes provider configuration
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

# Helm provider configuration
provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    }
  }
}

###############################################################################
# Local variables
###############################################################################

locals {

  #############################################################################
  # General
  #############################################################################

  region = var.region
  name   = var.name

  resource_tags = {
    "Owner"   = "${data.aws_caller_identity.current.user_id}"
    "Project" = "${var.name}"
  }

  #############################################################################
  # VPC
  #############################################################################

  azs = slice(data.aws_availability_zones.available.names, 0, length(data.aws_availability_zones.available.names))

  #############################################################################
  # AWS Cloud Map
  #############################################################################

  namespace_name = var.name
}

###############################################################################
# General data
###############################################################################

data "aws_caller_identity" "current" {}

###############################################################################
# VPC data
###############################################################################

data "aws_availability_zones" "available" {}