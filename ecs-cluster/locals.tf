locals {
  cloudwatch_log_group_name = var.create_cloudwatch_log_group != null ? aws_cloudwatch_log_group.this[0].name : null
}
