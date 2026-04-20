output "db_cluster_arn" {
  description = "The ARN of the Aurora cluster. Null when cluster_config is null."
  value       = var.cluster_config != null ? aws_rds_cluster.this[0].arn : null
}

output "db_cluster_database_name" {
  description = "The name of the initial database in the Aurora cluster. Null when cluster_config is null."
  value       = var.cluster_config != null ? aws_rds_cluster.this[0].database_name : null
}

output "db_cluster_endpoint" {
  description = "The write endpoint of the Aurora cluster. Null when cluster_config is null."
  value       = var.cluster_config != null ? aws_rds_cluster.this[0].endpoint : null
}

output "db_cluster_engine_version_actual" {
  description = "The running engine version of the Aurora cluster. Null when cluster_config is null."
  value       = var.cluster_config != null ? aws_rds_cluster.this[0].engine_version_actual : null
}

output "db_cluster_hosted_zone_id" {
  description = "The Route53 hosted zone ID of the Aurora cluster endpoint. Null when cluster_config is null."
  value       = var.cluster_config != null ? aws_rds_cluster.this[0].hosted_zone_id : null
}

output "db_cluster_id" {
  description = "The ID of the Aurora cluster. Null when cluster_config is null."
  value       = var.cluster_config != null ? aws_rds_cluster.this[0].id : null
}

output "db_cluster_instance_endpoints" {
  description = "Map of Aurora cluster instance identifiers to their endpoints. Empty when cluster_config is null."
  value       = { for _, v in aws_rds_cluster_instance.this : v.identifier => v.endpoint }
}

output "db_cluster_master_user_secret" {
  description = "Block with the Secrets Manager secret for the Aurora cluster master user password. Null when cluster_config is null or manage_master_user_password is false."
  value       = var.cluster_config != null && var.manage_master_user_password == true ? aws_rds_cluster.this[0].master_user_secret : null
}

output "db_cluster_master_username" {
  description = "The master username for the Aurora cluster. Null when cluster_config is null."
  value       = var.cluster_config != null ? aws_rds_cluster.this[0].master_username : null
  sensitive   = true
}

output "db_cluster_parameter_group_arn" {
  description = "The ARN of the Aurora cluster parameter group. Null when cluster_config is null or parameter_group_family is not set."
  value       = var.cluster_config != null && try(var.cluster_config.parameter_group_family, null) != null ? aws_rds_cluster_parameter_group.this[0].arn : null
}

output "db_cluster_parameter_group_id" {
  description = "The ID of the Aurora cluster parameter group. Null when cluster_config is null or parameter_group_family is not set."
  value       = var.cluster_config != null && try(var.cluster_config.parameter_group_family, null) != null ? aws_rds_cluster_parameter_group.this[0].id : null
}

output "db_cluster_port" {
  description = "The port on which the Aurora cluster accepts connections. Null when cluster_config is null."
  value       = var.cluster_config != null ? aws_rds_cluster.this[0].port : null
}

output "db_cluster_reader_endpoint" {
  description = "The read-only endpoint of the Aurora cluster. Null when cluster_config is null."
  value       = var.cluster_config != null ? aws_rds_cluster.this[0].reader_endpoint : null
}

output "db_cluster_resource_id" {
  description = "The RDS cluster resource ID. Null when cluster_config is null."
  value       = var.cluster_config != null ? aws_rds_cluster.this[0].cluster_resource_id : null
}

output "db_instance_address" {
  description = "The hostname of the RDS instance. Null when cluster_config is set."
  value       = var.cluster_config == null ? aws_db_instance.this[0].address : null
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance. Null when cluster_config is set."
  value       = var.cluster_config == null ? aws_db_instance.this[0].arn : null
}

output "db_instance_availability_zone" {
  description = "The availability zone of the RDS instance. Null when cluster_config is set."
  value       = var.cluster_config == null ? aws_db_instance.this[0].availability_zone : null
}

output "db_instance_ca_cert_identifier" {
  description = "The identifier of the CA certificate for the RDS instance. Null when cluster_config is set."
  value       = var.cluster_config == null ? aws_db_instance.this[0].ca_cert_identifier : null
}

output "db_instance_endpoint" {
  description = "The connection endpoint of the RDS instance (host:port). Null when cluster_config is set."
  value       = var.cluster_config == null ? aws_db_instance.this[0].endpoint : null
}

output "db_instance_engine_version_actual" {
  description = "The running engine version of the RDS instance. Null when cluster_config is set."
  value       = var.cluster_config == null ? aws_db_instance.this[0].engine_version_actual : null
}

output "db_instance_hosted_zone_id" {
  description = "The canonical Route53 hosted zone ID of the RDS instance endpoint. Null when cluster_config is set."
  value       = var.cluster_config == null ? aws_db_instance.this[0].hosted_zone_id : null
}

output "db_instance_id" {
  description = "The ID of the RDS instance. Null when cluster_config is set."
  value       = var.cluster_config == null ? aws_db_instance.this[0].id : null
}

output "db_instance_master_user_secret" {
  description = "Block with the Secrets Manager secret for the RDS instance master user password. Null when cluster_config is set or manage_master_user_password is false."
  value       = var.cluster_config == null && var.manage_master_user_password == true ? aws_db_instance.this[0].master_user_secret : null
}

output "db_instance_name" {
  description = "The name of the initial database on the RDS instance. Null when cluster_config is set."
  value       = var.cluster_config == null ? aws_db_instance.this[0].db_name : null
}

output "db_instance_port" {
  description = "The port on which the RDS instance accepts connections. Null when cluster_config is set."
  value       = var.cluster_config == null ? aws_db_instance.this[0].port : null
}

output "db_instance_resource_id" {
  description = "The RDS resource ID of the instance. Null when cluster_config is set."
  value       = var.cluster_config == null ? aws_db_instance.this[0].resource_id : null
}

output "db_instance_username" {
  description = "The master username for the RDS instance. Null when cluster_config is set."
  value       = var.cluster_config == null ? aws_db_instance.this[0].username : null
  sensitive   = true
}

output "db_option_group_arn" {
  description = "The ARN of the DB option group. Null when cluster_config is set or create_option_group is null."
  value       = var.cluster_config == null && var.create_option_group != null ? aws_db_option_group.this[0].arn : null
}

output "db_option_group_id" {
  description = "The ID of the DB option group. Null when cluster_config is set or create_option_group is null."
  value       = var.cluster_config == null && var.create_option_group != null ? aws_db_option_group.this[0].id : null
}

output "db_parameter_group_arn" {
  description = "The ARN of the DB parameter group. Null when create_parameter_group is null."
  value       = var.create_parameter_group != null ? aws_db_parameter_group.this[0].arn : null
}

output "db_parameter_group_id" {
  description = "The ID of the DB parameter group. Null when create_parameter_group is null."
  value       = var.create_parameter_group != null ? aws_db_parameter_group.this[0].id : null
}

output "db_subnet_group_arn" {
  description = "The ARN of the DB subnet group. Null when create_subnet_group is false."
  value       = var.create_subnet_group ? aws_db_subnet_group.this[0].arn : null
}

output "db_subnet_group_id" {
  description = "The ID of the DB subnet group. Null when create_subnet_group is false."
  value       = var.create_subnet_group ? aws_db_subnet_group.this[0].id : null
}
