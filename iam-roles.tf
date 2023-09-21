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
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [module.cloudtrail.cloudtrail_arn]
    }
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
# EKS Cluster IAM role
###############################################################################