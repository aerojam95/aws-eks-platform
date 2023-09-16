###############################################################################
# AWS cloud map module:https://github.com/aerojam95/aws-cloud-map.git
###############################################################################

module "namespace" {
  #############################################################################
  # AWS Cloud Map settings
  #############################################################################

  source  = "git@github.com:aerojam95/aws-cloud-map.git"
  region  = local.region
  tags    = local.resource_tags
  vpc_id  = module.vpc.vpc_id
  vpc_arn = [module.vpc.vpc_arn]

  #############################################################################
  # Cloud map namespace
  #############################################################################

  name        = local.namespace_name
  description = "AWS cloud map namespace for an AWS EKS container platform"

  namespace_tags = {
    "Name" = local.namespace_name
  }

}