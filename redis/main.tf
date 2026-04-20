resource "aws_elasticache_replication_group" "this" {
  lifecycle {
    precondition {
      condition     = var.num_node_groups <= 1 || var.automatic_failover_enabled
      error_message = "automatic_failover_enabled must be true when num_node_groups > 1 (Redis Cluster Mode)."
    }
    precondition {
      condition     = !var.multi_az_enabled || var.automatic_failover_enabled
      error_message = "automatic_failover_enabled must be true when multi_az_enabled is true."
    }
  }
  replication_group_id        = var.name
  description                 = var.description
  engine                      = var.engine
  global_replication_group_id = var.global_replication_group_id
  node_type                   = var.global_replication_group_id == null ? var.node_type : null
  num_cache_clusters          = var.global_replication_group_id != null ? var.num_cache_clusters : null
  num_node_groups             = var.global_replication_group_id == null ? var.num_node_groups : null
  replicas_per_node_group     = var.global_replication_group_id == null ? var.replicas_per_node_group : null
  engine_version              = var.engine_version
  port                        = var.port
  subnet_group_name           = local.subnet_group_name
  security_group_ids          = var.security_group_ids
  at_rest_encryption_enabled  = var.at_rest_encryption_enabled
  kms_key_id                  = var.at_rest_encryption_enabled ? var.kms_key_id : null
  transit_encryption_enabled  = var.transit_encryption_enabled
  transit_encryption_mode     = var.transit_encryption_enabled ? var.transit_encryption_mode : null
  auth_token                  = var.transit_encryption_enabled ? var.auth_token : null
  auth_token_update_strategy  = var.transit_encryption_enabled && var.auth_token != null ? var.auth_token_update_strategy : null
  automatic_failover_enabled  = var.automatic_failover_enabled
  multi_az_enabled            = var.multi_az_enabled
  cluster_mode                = var.cluster_mode
  data_tiering_enabled        = var.data_tiering_enabled
  ip_discovery                = var.ip_discovery
  network_type                = var.network_type
  preferred_cache_cluster_azs = var.preferred_cache_cluster_azs
  maintenance_window          = var.maintenance_window
  snapshot_window             = var.snapshot_window
  snapshot_retention_limit    = var.snapshot_retention_limit
  snapshot_arns               = var.snapshot_arns
  snapshot_name               = var.snapshot_name
  final_snapshot_identifier   = var.final_snapshot_identifier
  parameter_group_name        = local.parameter_group_name
  apply_immediately           = var.apply_immediately
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  notification_topic_arn      = var.notification_topic_arn
  user_group_ids              = length(var.user_group_ids) > 0 ? var.user_group_ids : null
  tags                        = { Name = var.name }
  dynamic "log_delivery_configuration" {
    for_each = var.log_delivery_configuration != null ? var.log_delivery_configuration : []
    content {
      destination      = log_delivery_configuration.value.destination
      destination_type = log_delivery_configuration.value.destination_type
      log_format       = log_delivery_configuration.value.log_format
      log_type         = log_delivery_configuration.value.log_type
    }
  }
}

resource "aws_elasticache_global_replication_group" "this" {
  count                                = var.create_global_replication_group != null ? 1 : 0
  global_replication_group_id_suffix   = var.create_global_replication_group.global_replication_group_id_suffix
  primary_replication_group_id         = aws_elasticache_replication_group.this.id
  global_replication_group_description = var.create_global_replication_group.description
  automatic_failover_enabled           = var.create_global_replication_group.automatic_failover_enabled
  cache_node_type                      = var.create_global_replication_group.cache_node_type
  engine                               = var.create_global_replication_group.engine
  engine_version                       = var.create_global_replication_group.engine_version
  num_node_groups                      = var.create_global_replication_group.num_node_groups
  parameter_group_name                 = var.create_global_replication_group.parameter_group_name
}

resource "aws_elasticache_subnet_group" "this" {
  count       = var.create_subnet_group != null ? 1 : 0
  name        = var.create_subnet_group.name
  subnet_ids  = var.create_subnet_group.subnet_ids
  description = var.create_subnet_group.description
  tags        = { Name = var.create_subnet_group.name }
}

resource "aws_elasticache_parameter_group" "this" {
  count       = var.create_parameter_group != null ? 1 : 0
  name        = var.create_parameter_group.name
  family      = var.create_parameter_group.family
  description = var.create_parameter_group.description
  tags        = { Name = var.create_parameter_group.name }
  dynamic "parameter" {
    for_each = var.create_parameter_group.parameters != null ? var.create_parameter_group.parameters : []
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }
}
