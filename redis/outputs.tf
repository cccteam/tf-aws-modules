output "arn" {
  description = "ARN of the ElastiCache replication group."
  value       = aws_elasticache_replication_group.this.arn
}

output "cluster_enabled" {
  description = "Whether cluster mode is enabled for the replication group."
  value       = aws_elasticache_replication_group.this.cluster_enabled
}

output "configuration_endpoint_address" {
  description = "Configuration endpoint address of the replication group. Only populated when cluster mode is enabled (num_node_groups > 1)."
  value       = aws_elasticache_replication_group.this.configuration_endpoint_address
}

output "engine_version_actual" {
  description = "Actual running Redis engine version. May differ from var.engine_version because ElastiCache determines the full patch version."
  value       = aws_elasticache_replication_group.this.engine_version_actual
}

output "id" {
  description = "ID of the ElastiCache replication group."
  value       = aws_elasticache_replication_group.this.id
}

output "member_clusters" {
  description = "Identifiers of all cache clusters that are part of the replication group."
  value       = aws_elasticache_replication_group.this.member_clusters
}

output "parameter_group_name" {
  description = "Name of the ElastiCache parameter group associated with the replication group. Null when neither create_parameter_group nor parameter_group_name is set."
  value       = var.create_parameter_group != null ? aws_elasticache_parameter_group.this[0].name : var.parameter_group_name
}

output "primary_endpoint_address" {
  description = "Address of the primary node endpoint. Only populated when cluster mode is disabled (num_node_groups = 1)."
  value       = aws_elasticache_replication_group.this.primary_endpoint_address
}

output "reader_endpoint_address" {
  description = "Address of the reader endpoint for the replication group. Only populated when cluster mode is disabled (num_node_groups = 1)."
  value       = aws_elasticache_replication_group.this.reader_endpoint_address
}

output "subnet_group_name" {
  description = "Name of the ElastiCache subnet group associated with the replication group. Null when neither create_subnet_group nor subnet_group_name is set."
  value       = var.create_subnet_group != null ? aws_elasticache_subnet_group.this[0].name : var.subnet_group_name
}

output "global_replication_group_arn" {
  description = "ARN of the ElastiCache Global Replication Group. Null when create_global_replication_group is not set."
  value       = var.create_global_replication_group != null ? aws_elasticache_global_replication_group.this[0].arn : null
}

output "global_replication_group_at_rest_encryption_enabled" {
  description = "Whether at-rest encryption is enabled for the Global Replication Group. Null when create_global_replication_group is not set."
  value       = var.create_global_replication_group != null ? aws_elasticache_global_replication_group.this[0].at_rest_encryption_enabled : null
}

output "global_replication_group_auth_token_enabled" {
  description = "Whether an auth token (password) is enabled for the Global Replication Group. Null when create_global_replication_group is not set."
  value       = var.create_global_replication_group != null ? aws_elasticache_global_replication_group.this[0].auth_token_enabled : null
}

output "global_replication_group_cluster_enabled" {
  description = "Whether cluster mode is enabled for the Global Replication Group. Null when create_global_replication_group is not set."
  value       = var.create_global_replication_group != null ? aws_elasticache_global_replication_group.this[0].cluster_enabled : null
}

output "global_replication_group_engine_version_actual" {
  description = "Actual running engine version of the Global Replication Group. Null when create_global_replication_group is not set."
  value       = var.create_global_replication_group != null ? aws_elasticache_global_replication_group.this[0].engine_version_actual : null
}

output "global_replication_group_id" {
  description = "Full ID of the ElastiCache Global Replication Group. Null when create_global_replication_group is not set."
  value       = var.create_global_replication_group != null ? aws_elasticache_global_replication_group.this[0].global_replication_group_id : null
}

output "global_replication_group_node_groups" {
  description = "Set of node groups belonging to the Global Replication Group, each with global_node_group_id and slots. Null when create_global_replication_group is not set."
  value       = var.create_global_replication_group != null ? aws_elasticache_global_replication_group.this[0].global_node_groups : null
}

output "global_replication_group_transit_encryption_enabled" {
  description = "Whether in-transit encryption is enabled for the Global Replication Group. Null when create_global_replication_group is not set."
  value       = var.create_global_replication_group != null ? aws_elasticache_global_replication_group.this[0].transit_encryption_enabled : null
}
