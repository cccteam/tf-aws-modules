output "ssm_maintenance_task_service_role_arn" {
  description = "ARN of the service role if created by module"
  value       = try(aws_ssm_maintenance_window_task.baseline[0].service_role_arn, null)
}

output "ssm_cloudwatch_log_group_arn" {
  value = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${var.cloudwatch_log_group_name}"
}
