###############################################################################
# CloudTrail module: https://github.com/cloudposse/terraform-aws-cloudtrail.git
###############################################################################

module "cloudtrail" {
  #############################################################################
  # CT settings
  #############################################################################

  source  = "cloudposse/cloudtrail/aws"
  version = "~> 0.23.0"

  #############################################################################
  # CT
  #############################################################################

  name                          = format("${local.name}-ct-trail")
  s3_bucket_name                = module.s3_bucket_ct_logs.s3_bucket_id
  is_multi_region_trail         = var.is_multi_region_trail
  include_global_service_events = var.include_global_service_events
  cloud_watch_logs_role_arn     = aws_iam_role.aws_ct_iam_role.arn
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.aws_ct_cw_log_group.arn}:*"
  insight_selector              = var.insight_selector
  event_selector                = var.event_selector

  tags = merge(
    { "Name" = format("${local.name}-ct-trail") },
    local.resource_tags
  )

}

resource "aws_cloudwatch_log_group" "aws_ct_cw_log_group" {
  name       = "/aws/${local.name}/cw-group-ct-logs/ct-logging"
  kms_key_id = module.ct_logs_cw_logs_kms_key.key_arn

  tags = merge(
    { "Name" = format("${local.name}-ct-trail-cw-logs-group") },
    local.resource_tags
  )

}