###############################################################################
# CT IAM role
###############################################################################

resource "aws_iam_role" "aws_ct_iam_role" {

  name_prefix        = "aws-ct-iam-role-"
  assume_role_policy = data.aws_iam_policy_document.aws_ct_assume_role.json

  tags = merge(
    { "Name" = format("${local.name}-aws-ct-iam-role") },
    local.resource_tags
  )

}

data "aws_iam_policy_document" "aws_ct_assume_role" {

  statement {
    sid = "AWSCTAssumeRole"
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
  }

}

resource "aws_iam_role_policy_attachment" "aws_ct_attachment" {

  role       = aws_iam_role.aws_ct_iam_role.name
  policy_arn = aws_iam_policy.aws_ct_iam_policy.arn

}

resource "aws_iam_policy" "aws_ct_iam_policy" {

  name_prefix = "aws-ct-iam-role-"
  policy      = data.aws_iam_policy_document.aws_ct_iam_policy_document.json

  tags = merge(
    { "Name" = format("${local.name}-aws-ct-iam-role") },
    local.resource_tags
  )

}

data "aws_iam_policy_document" "aws_ct_iam_policy_document" {

  statement {
    sid    = "AWSCTS3Access"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetBucketAcl",
      "s3:GetBucketPolicy",
    ]
    resources = [
      "${module.s3_bucket_ct_logs.s3_bucket_arn}/*",
      module.s3_bucket_ct_logs.s3_bucket_arn
    ]
  }

  statement {
    sid    = "AWSCTLogsPushToCloudWatch"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]
    resources = ["${aws_cloudwatch_log_group.aws_ct_cw_log_group.arn}:*"]
  }

}

###############################################################################
# EKS container platform user Admin IAM role
###############################################################################

resource "aws_iam_role" "admin_iam_role" {

  name_prefix        = "admin-"
  assume_role_policy = data.aws_iam_policy_document.admin_assume_role.json

  tags = merge(
    { "Name" = format("${local.name}-admin-iam-role") },
    local.resource_tags
  )

}

data "aws_iam_policy_document" "admin_assume_role" {
  statement {
    sid = "AWSEKSContainerPlatformAdminAssumeRole"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "admin_attachment" {

  role       = aws_iam_role.admin_iam_role.name
  policy_arn = aws_iam_policy.admin_iam_policy.arn

}

resource "aws_iam_policy" "admin_iam_policy" {

  name_prefix = "admin-iam-role-"
  policy      = data.aws_iam_policy_document.admin_iam_policy_document.json

  tags = merge(
    { "Name" = format("${local.name}-admin-iam-role") },
    local.resource_tags
  )

}

data "aws_iam_policy_document" "admin_iam_policy_document" {


  statement {
    sid     = "AWSEKSContainerPlatformAdminIAM"
    effect  = "Allow"
    actions = ["iam:*"]
    resources = [
      module.vpc.vpc_flow_log_cloudwatch_iam_role_arn,
      aws_iam_role.aws_ct_iam_role.arn,
      module.eks.cluster_iam_role_arn
    ]
  }

  statement {
    sid    = "AWSEKSContainerPlatformAdminCW"
    effect = "Allow"
    actions = [
      "cloudwatch:*",
      "logs:*"
    ]
    resources = [
      module.vpc.vpc_flow_log_destination_arn,
      module.eks.cloudwatch_log_group_arn,
      aws_cloudwatch_log_group.aws_ct_cw_log_group.arn
    ]
  }

  statement {
    sid     = "AWSEKSContainerPlatformAdminCT"
    effect  = "Allow"
    actions = ["cloudtrail:*"]
    resources = [
      module.cloudtrail.cloudtrail_arn
    ]
  }

  statement {
    sid     = "AWSEKSContainerPlatformAdminKMS"
    effect  = "Allow"
    actions = ["kms:*"]
    resources = [
      module.vpc_flow_log_kms_key.key_arn,
      module.ct_logs_s3_bucket_kms_key.key_arn,
      module.ct_logs_cw_logs_kms_key.key_arn,
      module.eks_cluster_logs_kms_key.key_arn,
      module.eks.kms_key_arn
    ]
  }

  statement {
    sid    = "AWSEKSContainerPlatformAdminNetworking"
    effect = "Allow"
    actions = [
      "ec2:*"
      # "ec2:AcceptVpcPeeringConnection",
      # "ec2:AcceptVpcEndpointConnections",
      # "ec2:AllocateAddress",
      # "ec2:AssignIpv6Addresses",
      # "ec2:AssignPrivateIpAddresses",
      # "ec2:AssociateAddress",
      # "ec2:AssociateDhcpOptions",
      # "ec2:AssociateRouteTable",
      # "ec2:AssociateSubnetCidrBlock",
      # "ec2:AssociateVpcCidrBlock",
      # "ec2:AttachClassicLinkVpc",
      # "ec2:AttachInternetGateway",
      # "ec2:AttachNetworkInterface",
      # "ec2:AttachVpnGateway",
      # "ec2:AuthorizeSecurityGroupEgress",
      # "ec2:AuthorizeSecurityGroupIngress",
      # "ec2:CreateCarrierGateway",
      # "ec2:CreateCustomerGateway",
      # "ec2:CreateDefaultSubnet",
      # "ec2:CreateDefaultVpc",
      # "ec2:CreateDhcpOptions",
      # "ec2:CreateEgressOnlyInternetGateway",
      # "ec2:CreateFlowLogs",
      # "ec2:CreateInternetGateway",
      # "ec2:CreateLocalGatewayRouteTableVpcAssociation",
      # "ec2:CreateNatGateway",
      # "ec2:CreateNetworkAcl",
      # "ec2:CreateNetworkAclEntry",
      # "ec2:CreateNetworkInterface",
      # "ec2:CreateNetworkInterfacePermission",
      # "ec2:CreateRoute",
      # "ec2:CreateRouteTable",
      # "ec2:CreateSecurityGroup",
      # "ec2:CreateSubnet",
      # "ec2:CreateTags",
      # "ec2:CreateVpc",
      # "ec2:CreateVpcEndpoint",
      # "ec2:CreateVpcEndpointConnectionNotification",
      # "ec2:CreateVpcEndpointServiceConfiguration",
      # "ec2:CreateVpcPeeringConnection",
      # "ec2:CreateVpnConnection",
      # "ec2:CreateVpnConnectionRoute",
      # "ec2:CreateVpnGateway",
      # "ec2:DeleteCarrierGateway",
      # "ec2:DeleteCustomerGateway",
      # "ec2:DeleteDhcpOptions",
      # "ec2:DeleteEgressOnlyInternetGateway",
      # "ec2:DeleteFlowLogs",
      # "ec2:DeleteInternetGateway",
      # "ec2:DeleteLocalGatewayRouteTableVpcAssociation",
      # "ec2:DeleteNatGateway",
      # "ec2:DeleteNetworkAcl",
      # "ec2:DeleteNetworkAclEntry",
      # "ec2:DeleteNetworkInterface",
      # "ec2:DeleteNetworkInterfacePermission",
      # "ec2:DeleteRoute",
      # "ec2:DeleteRouteTable",
      # "ec2:DeleteSecurityGroup",
      # "ec2:DeleteSubnet",
      # "ec2:DeleteTags",
      # "ec2:DeleteVpc",
      # "ec2:DeleteVpcEndpoints",
      # "ec2:DeleteVpcEndpointConnectionNotifications",
      # "ec2:DeleteVpcEndpointServiceConfigurations",
      # "ec2:DeleteVpcPeeringConnection",
      # "ec2:DeleteVpnConnection",
      # "ec2:DeleteVpnConnectionRoute",
      # "ec2:DeleteVpnGateway",
      # "ec2:DescribeAccountAttributes",
      # "ec2:DescribeAddresses",
      # "ec2:DescribeAvailabilityZones",
      # "ec2:DescribeCarrierGateways",
      # "ec2:DescribeClassicLinkInstances",
      # "ec2:DescribeCustomerGateways",
      # "ec2:DescribeDhcpOptions",
      # "ec2:DescribeEgressOnlyInternetGateways",
      # "ec2:DescribeFlowLogs",
      # "ec2:DescribeInstances",
      # "ec2:DescribeInternetGateways",
      # "ec2:DescribeIpv6Pools",
      # "ec2:DescribeLocalGatewayRouteTables",
      # "ec2:DescribeLocalGatewayRouteTableVpcAssociations",
      # "ec2:DescribeKeyPairs",
      # "ec2:DescribeMovingAddresses",
      # "ec2:DescribeNatGateways",
      # "ec2:DescribeNetworkAcls",
      # "ec2:DescribeNetworkInterfaceAttribute",
      # "ec2:DescribeNetworkInterfacePermissions",
      # "ec2:DescribeNetworkInterfaces",
      # "ec2:DescribePrefixLists",
      # "ec2:DescribeRouteTables",
      # "ec2:DescribeSecurityGroupReferences",
      # "ec2:DescribeSecurityGroupRules",
      # "ec2:DescribeSecurityGroups",
      # "ec2:DescribeStaleSecurityGroups",
      # "ec2:DescribeSubnets",
      # "ec2:DescribeTags",
      # "ec2:DescribeVpcAttribute",
      # "ec2:DescribeVpcClassicLink",
      # "ec2:DescribeVpcClassicLinkDnsSupport",
      # "ec2:DescribeVpcEndpointConnectionNotifications",
      # "ec2:DescribeVpcEndpointConnections",
      # "ec2:DescribeVpcEndpoints",
      # "ec2:DescribeVpcEndpointServiceConfigurations",
      # "ec2:DescribeVpcEndpointServicePermissions",
      # "ec2:DescribeVpcEndpointServices",
      # "ec2:DescribeVpcPeeringConnections",
      # "ec2:DescribeVpcs",
      # "ec2:DescribeVpnConnections",
      # "ec2:DescribeVpnGateways",
      # "ec2:DetachClassicLinkVpc",
      # "ec2:DetachInternetGateway",
      # "ec2:DetachNetworkInterface",
      # "ec2:DetachVpnGateway",
      # "ec2:DisableVgwRoutePropagation",
      # "ec2:DisableVpcClassicLink",
      # "ec2:DisableVpcClassicLinkDnsSupport",
      # "ec2:DisassociateAddress",
      # "ec2:DisassociateRouteTable",
      # "ec2:DisassociateSubnetCidrBlock",
      # "ec2:DisassociateVpcCidrBlock",
      # "ec2:EnableVgwRoutePropagation",
      # "ec2:EnableVpcClassicLink",
      # "ec2:EnableVpcClassicLinkDnsSupport",
      # "ec2:ModifyNetworkInterfaceAttribute",
      # "ec2:ModifySecurityGroupRules",
      # "ec2:ModifySubnetAttribute",
      # "ec2:ModifyVpcAttribute",
      # "ec2:ModifyVpcEndpoint",
      # "ec2:ModifyVpcEndpointConnectionNotification",
      # "ec2:ModifyVpcEndpointServiceConfiguration",
      # "ec2:ModifyVpcEndpointServicePermissions",
      # "ec2:ModifyVpcPeeringConnectionOptions",
      # "ec2:ModifyVpcTenancy",
      # "ec2:MoveAddressToVpc",
      # "ec2:RejectVpcEndpointConnections",
      # "ec2:RejectVpcPeeringConnection",
      # "ec2:ReleaseAddress",
      # "ec2:ReplaceNetworkAclAssociation",
      # "ec2:ReplaceNetworkAclEntry",
      # "ec2:ReplaceRoute",
      # "ec2:ReplaceRouteTableAssociation",
      # "ec2:ResetNetworkInterfaceAttribute",
      # "ec2:RestoreAddressToClassic",
      # "ec2:RevokeSecurityGroupEgress",
      # "ec2:RevokeSecurityGroupIngress",
      # "ec2:UnassignIpv6Addresses",
      # "ec2:UnassignPrivateIpAddresses",
      # "ec2:UpdateSecurityGroupRuleDescriptionsEgress",
      # "ec2:UpdateSecurityGroupRuleDescriptionsIngress"
    ]
    resources = [
      module.vpc.vpc_arn,
      module.vpc_endpoints_sg.security_group_arn,
      module.eks.cluster_security_group_arn,
      module.eks.node_security_group_arn
    ]
  }

  statement {
    sid       = "AWSEKSContainerPlatformAdminEKS"
    effect    = "Allow"
    actions   = ["eks:*"]
    resources = [module.eks.cluster_arn]
  }

  statement {
    sid     = "AWSEKSContainerPlatformAdminS3"
    effect  = "Allow"
    actions = ["s3:*"]
    resources = [
      "${module.s3_bucket_ct_logs.s3_bucket_arn}/*",
      module.s3_bucket_ct_logs.s3_bucket_arn
    ]
  }

}