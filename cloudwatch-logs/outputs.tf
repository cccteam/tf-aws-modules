output "log_group_arn" {
  description = "The ARN of the CloudWatch log group."
  value       = aws_cloudwatch_log_group.this.arn
}

output "log_group_name" {
  description = "The name of the CloudWatch log group."
  value       = aws_cloudwatch_log_group.this.name
}

output "metric_filter_ids" {
  description = "Map of metric filter names to their IDs."
  value       = { for k, v in aws_cloudwatch_log_metric_filter.this : k => v.id }
}

output "query_definition_ids" {
  description = "Map of query definition names to their query_definition_id."
  value       = { for k, v in aws_cloudwatch_query_definition.this : k => v.query_definition_id }
}

output "resource_policy_id" {
  description = "The ID of the resource policy (policy name for account-scoped, log group ARN for resource-scoped). Null when resource_policy is not configured."
  value       = var.resource_policy != null ? aws_cloudwatch_log_resource_policy.this[0].id : null
}

output "resource_policy_revision_id" {
  description = "The revision ID of the resource policy. Only populated for resource-scoped policies. Null when resource_policy is not configured."
  value       = var.resource_policy != null ? aws_cloudwatch_log_resource_policy.this[0].revision_id : null
}

output "resource_policy_scope" {
  description = "The scope of the resource policy: ACCOUNT or RESOURCE. Null when resource_policy is not configured."
  value       = var.resource_policy != null ? aws_cloudwatch_log_resource_policy.this[0].policy_scope : null
}

output "subscription_filter_name" {
  description = "The name of the subscription filter. Null when subscription_filter is not configured."
  value       = var.subscription_filter != null ? aws_cloudwatch_log_subscription_filter.this[0].name : null
}
