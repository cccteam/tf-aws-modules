resource "aws_cloudwatch_log_group" "this" {
  lifecycle {
    precondition {
      condition     = !(var.name != null && var.name_prefix != null)
      error_message = "name and name_prefix are mutually exclusive; set only one."
    }
  }
  region                      = var.region
  name                        = var.name
  name_prefix                 = var.name_prefix
  skip_destroy                = var.skip_destroy
  deletion_protection_enabled = var.deletion_protection_enabled
  retention_in_days           = var.log_group_class == "DELIVERY" ? null : var.retention_in_days
  kms_key_id                  = var.kms_key_id
  log_group_class             = var.log_group_class
  tags                        = try({ Name = coalesce(var.name, var.name_prefix) }, {})
}

resource "aws_cloudwatch_log_subscription_filter" "this" {
  count                     = var.subscription_filter != null ? 1 : 0
  destination_arn           = var.subscription_filter.destination_arn
  distribution              = var.subscription_filter.distribution
  emit_system_fields        = var.subscription_filter.emit_system_fields
  filter_pattern            = var.subscription_filter.filter_pattern
  log_group_name            = aws_cloudwatch_log_group.this.name
  name                      = var.subscription_filter.name
  region                    = var.region
  apply_on_transformed_logs = var.subscription_filter.apply_on_transformed_logs
  role_arn                  = var.subscription_filter.role_arn
}

resource "aws_cloudwatch_log_metric_filter" "this" {
  for_each                  = { for f in var.metric_filters : f.name => f }
  region                    = var.region
  name                      = each.value.name
  pattern                   = each.value.pattern
  log_group_name            = aws_cloudwatch_log_group.this.name
  apply_on_transformed_logs = each.value.apply_on_transformed_logs
  metric_transformation {
    name          = each.value.metric_transformation.name
    namespace     = each.value.metric_transformation.namespace
    value         = each.value.metric_transformation.value
    default_value = each.value.metric_transformation.default_value
    dimensions    = each.value.metric_transformation.dimensions
    unit          = each.value.metric_transformation.unit
  }
}

resource "aws_cloudwatch_log_resource_policy" "this" {
  count           = var.resource_policy != null ? 1 : 0
  region          = var.region
  policy_document = var.resource_policy.policy_document
  policy_name     = var.resource_policy.policy_name
  resource_arn    = var.resource_policy.policy_name == null ? aws_cloudwatch_log_group.this.arn : null
}

resource "aws_cloudwatch_log_data_protection_policy" "this" {
  count           = var.data_protection_policy_document != null ? 1 : 0
  log_group_name  = aws_cloudwatch_log_group.this.name
  policy_document = var.data_protection_policy_document
  region          = var.region
}

resource "aws_cloudwatch_query_definition" "this" {
  for_each        = { for q in var.query_definitions : q.name => q }
  name            = each.value.name
  query_string    = each.value.query_string
  log_group_names = each.value.log_group_names != null ? each.value.log_group_names : [aws_cloudwatch_log_group.this.name]
  region          = var.region
}
