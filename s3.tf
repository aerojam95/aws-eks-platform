###############################################################################
# S3 bucket: https://github.com/terraform-aws-modules/terraform-aws-s3-bucket.git
###############################################################################

###############################################################################
# S3 bucket for CT logging
###############################################################################

module "s3_bucket_ct_logs" {
  #############################################################################
  # S3 bucket settings
  #############################################################################

  source = "terraform-aws-modules/s3-bucket/aws"

  #############################################################################
  # S3 bucket
  #############################################################################

  bucket = format("${local.name}-s3-bucket-ct-logs-tester-logger")
  #acl                 = "log-delivery-write"
  policy              = data.aws_iam_policy_document.s3_bucket_ct_logs_policy_document.json
  allowed_kms_key_arn = module.ct_logs_s3_bucket_kms_key.key_arn

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = module.ct_logs_s3_bucket_kms_key.key_arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  versioning = {
    enabled = true
  }

  logging = {
    target_bucket = module.s3_bucket_ct_logs.s3_bucket_id
    target_prefix = "ecs-cluster-ct-logs/"
  }

  lifecycle_rule = [
    {
      id      = "ecs-cluster-ct-log"
      enabled = true
      prefix  = "ecs-cluster-ct-logs/"
      tags = {
        rule      = "ecs-cluster-ct-logs"
        autoclean = "true"
      }
      transition = [
        {
          days          = 30
          storage_class = "ONEZONE_IA"
          }, {
          days          = 60
          storage_class = "GLACIER"
        }
      ]
      expiration = {
        days = 90
      }
      noncurrent_version_expiration = {
        days = 30
      }
    }
  ]

  force_destroy            = true
  control_object_ownership = true
  object_ownership         = "ObjectWriter"
  attach_policy            = true

  tags = merge(
    { "Name" = format("${local.name}-s3-bucket-ct-logs") },
    local.resource_tags
  )
}

data "aws_iam_policy_document" "s3_bucket_ct_logs_policy_document" {
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [module.s3_bucket_ct_logs.s3_bucket_arn]
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions = ["s3:PutObject"]
    resources = [
      module.s3_bucket_ct_logs.s3_bucket_arn,
      "${module.s3_bucket_ct_logs.s3_bucket_arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}