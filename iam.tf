###############################################################################
# AWS Cloud Map namespace IAM role
###############################################################################

resource "aws_iam_role" "aws_cloud_map_iam_role" {
  name_prefix        = "aws-cloud-map-iam-role-"
  assume_role_policy = data.aws_iam_policy_document.aws_cloud_map_assume_role.json

  tags = merge(
    { "Name" = format("${var.name}-aws-cloud-map-iam-role") },
    var.tags
  )

}

data "aws_iam_policy_document" "aws_cloud_map_assume_role" {

  statement {
    sid = "AWSCloudMapAssumeRole"
    principals {
      type        = "Service"
      identifiers = ["servicediscovery.amazonaws.com"]
    }
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
  }

}

resource "aws_iam_role_policy_attachment" "aws_cloud_map_attachment" {
  role       = aws_iam_role.aws_cloud_map_iam_role.name
  policy_arn = aws_iam_policy.aws_cloud_map_iam_policy.arn
}

resource "aws_iam_policy" "aws_cloud_map_iam_policy" {
  name_prefix = "aws-cloud-map-iam-role-"
  policy      = data.aws_iam_policy_document.aws_cloud_map_iam_policy_document.json

  tags = merge(
    { "Name" = format("${var.name}-aws-cloud-map-iam-role") },
    var.tags
  )

}

data "aws_iam_policy_document" "aws_cloud_map_iam_policy_document" {

  statement {
    sid    = "AWSCloudMapECSClusterAccess"
    effect = "Allow"
    actions = [
      "eks:CreateCluster",
      "eks:DeleteCluster",
      "eks:DescribeCluster",
      "eks:ListClusters",
    ]
    resources = [module.eks-cluster.arn]
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [module.namespace.namespace_arn]
    }
  }

}