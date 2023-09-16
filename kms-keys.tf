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