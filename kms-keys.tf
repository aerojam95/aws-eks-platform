###############################################################################
# KMS key: https://github.com/terraform-aws-modules/terraform-aws-kms.git
###############################################################################

###############################################################################
# KMS key for CloudWatch log groups for VPC flow logs
###############################################################################

module "vpc_flow_log_kms_key" {
  source      = "terraform-aws-modules/kms/aws"
  version     = "~> 1.5.0"
  description = "${var.name} AWS CloudWatch VPC flow logs Encryption KMS Key"
  key_owners  = ["${data.aws_caller_identity.current.arn}"]

  key_statements = [
    {
      sid = "CloudWatchLogs"
      actions = [
        "kms:Encrypt*",
        "kms:Decrypt*",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:Describe*"
      ]
      resources = ["*"]
      principals = [
        {
          type        = "Service"
          identifiers = ["logs.${local.region}.amazonaws.com"]
        }
      ]
      conditions = [
        {
          test     = "ArnLike"
          variable = "kms:EncryptionContext:aws:logs:arn"
          values = [
            "arn:aws:logs:${local.region}:${data.aws_caller_identity.current.account_id}:log-group:*",
          ]
        }
      ]
    }
  ]

  aliases = ["${var.name}-cw-vpc-flow-logs-kms-key"]

  tags = merge(
    { "Name" = "${var.name}-cw-vpc-flow-logs-kms-key" },
    local.resource_tags
  )
  
}

###############################################################################
# CT logging S3 bucket KMS key
###############################################################################

module "ct_logs_s3_bucket_kms_key" {
  source      = "terraform-aws-modules/kms/aws"
  version     = "~> 1.5.0"
  description = "${local.name} CT logs S3 bucket Encryption KMS Key"
  key_owners  = ["${data.aws_caller_identity.current.arn}"]

  key_statements = [
    {
      sid = "CTLogsS3"
      actions = [
        "kms:Encrypt*",
        "kms:Decrypt*",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:Describe*"
      ]
      resources = ["*"]

      principals = [
        {
          type        = "Service"
          identifiers = ["s3.amazonaws.com"]
        }
      ]

      conditions = [
        {
          test     = "ArnLike"
          variable = "aws:SourceArn"
          values = [
            "${module.s3_bucket_ct_logs.s3_bucket_arn}",
          ]
        }
      ]
    }
  ]

  aliases = ["${local.name}-ct-logs-s3-bucket-kms-key"]

  tags = merge(
    { "Name" = "${local.name}-ct-logs-s3-bucket-kms-key" },
    local.resource_tags
  )

}

###############################################################################
# CT logging CW logging KMS key
###############################################################################

module "ct_logs_cw_logs_kms_key" {
  source      = "terraform-aws-modules/kms/aws"
  version     = "~> 1.5.0"
  description = "${local.name} CT logs CW Logs Encryption KMS Key"
  key_owners  = ["${data.aws_caller_identity.current.arn}"]

  key_statements = [
    {
      sid = "CTLogsCWLogs"
      actions = [
        "kms:Encrypt*",
        "kms:Decrypt*",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:Describe*"
      ]
      resources = ["*"]

      principals = [
        {
          type        = "Service"
          identifiers = ["logs.${local.region}.amazonaws.com"]
        }
      ]

      conditions = [
        {
          test     = "ArnLike"
          variable = "kms:EncryptionContext:aws:logs:arn"
          values = [
            "arn:aws:logs:${local.region}:${data.aws_caller_identity.current.account_id}:log-group:*",
          ]
        }
      ]
    }
  ]

  aliases = ["${local.name}-ct-logs-cw-logs-kms-key"]

  tags = merge(
    { "Name" = "${local.name}-ct-logs-cw-logs-kms-key" },
    local.resource_tags
  )

}