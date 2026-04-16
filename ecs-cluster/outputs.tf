output "cloudwatch_log_group_arn" {
  description = "ARN of the CloudWatch log group created for ECS Exec logging. Null when create_cloudwatch_log_group is not set."
  value       = var.create_cloudwatch_log_group != null ? aws_cloudwatch_log_group.this[0].arn : null
}

output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group created for ECS Exec logging. Null when create_cloudwatch_log_group is not set."
  value       = var.create_cloudwatch_log_group != null ? aws_cloudwatch_log_group.this[0].name : null
}

output "cluster_arn" {
  description = "ARN of the ECS cluster."
  value       = aws_ecs_cluster.this.arn
}

output "cluster_id" {
  description = "ID of the ECS cluster."
  value       = aws_ecs_cluster.this.id
}

output "cluster_name" {
  description = "Name of the ECS cluster."
  value       = aws_ecs_cluster.this.name
}

output "service_discovery_namespace_arn" {
  description = "ARN of the service discovery private DNS namespace. Null when service_discovery_namespace is not set."
  value       = var.service_discovery_namespace != null ? aws_service_discovery_private_dns_namespace.this[0].arn : null
}

output "service_discovery_namespace_hosted_zone" {
  description = "Hosted zone ID of the service discovery private DNS namespace. Null when service_discovery_namespace is not set."
  value       = var.service_discovery_namespace != null ? aws_service_discovery_private_dns_namespace.this[0].hosted_zone : null
}

output "service_discovery_namespace_id" {
  description = "ID of the service discovery private DNS namespace. Null when service_discovery_namespace is not set."
  value       = var.service_discovery_namespace != null ? aws_service_discovery_private_dns_namespace.this[0].id : null
}
