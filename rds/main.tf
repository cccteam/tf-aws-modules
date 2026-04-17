resource "aws_db_subnet_group" "this" {
  count       = var.create_subnet_group ? 1 : 0
  name        = var.identifier
  subnet_ids  = var.subnet_ids
  description = "Subnet group for ${var.identifier}"
  tags        = { Name = var.identifier }
  region      = var.region
}

resource "aws_db_parameter_group" "this" {
  count        = var.create_parameter_group != null ? 1 : 0
  name         = var.identifier
  family       = var.create_parameter_group.family
  description  = var.create_parameter_group.description
  tags         = { Name = var.identifier }
  region       = var.region
  skip_destroy = var.skip_destroy
  dynamic "parameter" {
    for_each = var.create_parameter_group.parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }
}

resource "aws_rds_cluster_parameter_group" "this" {
  count       = var.cluster_config != null && var.cluster_config.parameter_group_family != null ? 1 : 0
  name        = var.identifier
  family      = var.cluster_config.parameter_group_family
  description = "Cluster parameter group for ${var.identifier}"
  tags        = { Name = var.identifier }
  region      = var.region
  dynamic "parameter" {
    for_each = var.cluster_config.parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }
}

resource "aws_db_option_group" "this" {
  count                    = var.cluster_config == null && var.create_option_group != null ? 1 : 0
  name                     = var.identifier
  option_group_description = var.create_option_group.description
  engine_name              = var.create_option_group.engine_name
  major_engine_version     = var.create_option_group.major_engine_version
  tags                     = { Name = var.identifier }
  region                   = var.region
  skip_destroy             = var.skip_destroy
  dynamic "option" {
    for_each = var.create_option_group.options
    content {
      option_name = option.value.option_name
      port        = option.value.port
      dynamic "option_settings" {
        for_each = option.value.option_settings
        content {
          name  = option_settings.value.name
          value = option_settings.value.value
        }
      }
    }
  }
}

resource "aws_db_instance" "this" {
  depends_on                            = [aws_db_subnet_group.this]
  count                                 = var.cluster_config == null ? 1 : 0
  identifier                            = var.identifier
  tags                                  = { Name = var.identifier }
  region                                = var.region
  engine                                = var.engine
  engine_version                        = var.engine_version
  instance_class                        = var.instance_class
  username                              = var.master_username
  password                              = var.master_password
  manage_master_user_password           = var.manage_master_user_password
  db_name                               = var.database_name
  port                                  = var.port
  allocated_storage                     = var.allocated_storage
  max_allocated_storage                 = var.max_allocated_storage
  storage_type                          = var.storage_type
  storage_throughput                    = var.storage_throughput
  storage_encrypted                     = true
  kms_key_id                            = var.kms_key_id
  iops                                  = var.iops
  dedicated_log_volume                  = var.dedicated_log_volume
  db_subnet_group_name                  = local.db_subnet_group_name
  parameter_group_name                  = var.create_parameter_group != null ? aws_db_parameter_group.this[0].name : var.db_parameter_group_name
  option_group_name                     = var.create_option_group != null ? aws_db_option_group.this[0].name : var.option_group_name
  vpc_security_group_ids                = var.vpc_security_group_ids
  multi_az                              = var.multi_az
  publicly_accessible                   = var.publicly_accessible
  deletion_protection                   = var.deletion_protection
  license_model                         = var.license_model
  skip_final_snapshot                   = var.skip_final_snapshot
  final_snapshot_identifier             = var.skip_final_snapshot ? null : var.final_snapshot_identifier
  backup_retention_period               = var.backup_retention_period
  backup_window                         = var.backup_window
  maintenance_window                    = var.maintenance_window
  apply_immediately                     = var.apply_immediately
  auto_minor_version_upgrade            = var.auto_minor_version_upgrade
  copy_tags_to_snapshot                 = var.copy_tags_to_snapshot
  enabled_cloudwatch_logs_exports       = var.enabled_cloudwatch_logs_exports
  monitoring_interval                   = var.enhanced_monitoring_interval
  monitoring_role_arn                   = var.monitoring_role_arn
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_kms_key_id       = var.performance_insights_enabled ? var.performance_insights_kms_key_id : null
  performance_insights_retention_period = var.performance_insights_enabled ? var.performance_insights_retention_period : null
  ca_cert_identifier                    = var.ca_cert_identifier
  snapshot_identifier                   = var.snapshot_identifier
  iam_database_authentication_enabled   = var.iam_database_authentication_enabled
  allow_major_version_upgrade           = var.allow_major_version_upgrade
  delete_automated_backups              = var.delete_automated_backups
  network_type                          = var.network_type
  master_user_secret_kms_key_id         = var.master_user_secret_kms_key_id
  availability_zone                     = var.availability_zone
  replicate_source_db                   = var.replicate_source_db
  character_set_name                    = var.character_set_name
  nchar_character_set_name              = var.nchar_character_set_name
  timezone                              = var.timezone
  domain                                = var.domain
  domain_iam_role_name                  = var.domain_iam_role_name
  domain_fqdn                           = var.domain_fqdn
  domain_ou                             = var.domain_ou
  domain_auth_secret_arn                = var.domain_auth_secret_arn
  domain_dns_ips                        = var.domain_dns_ips
  engine_lifecycle_support              = var.engine_lifecycle_support
  replica_mode                          = var.replica_mode
  upgrade_storage_config                = var.upgrade_storage_config
  database_insights_mode                = var.database_insights_mode
  dynamic "restore_to_point_in_time" {
    for_each = var.restore_to_point_in_time != null ? [var.restore_to_point_in_time] : []
    content {
      source_db_instance_identifier            = restore_to_point_in_time.value.source_db_instance_identifier
      restore_time                             = restore_to_point_in_time.value.restore_time
      use_latest_restorable_time               = restore_to_point_in_time.value.use_latest_restorable_time
      source_db_instance_automated_backups_arn = restore_to_point_in_time.value.source_db_instance_automated_backups_arn
      source_dbi_resource_id                   = restore_to_point_in_time.value.source_dbi_resource_id
    }
  }
  dynamic "blue_green_update" {
    for_each = var.blue_green_update != null ? [var.blue_green_update] : []
    content {
      enabled = blue_green_update.value.enabled
    }
  }
}

resource "aws_rds_cluster" "this" {
  depends_on                            = [aws_db_subnet_group.this]
  count                                 = var.cluster_config != null ? 1 : 0
  cluster_identifier                    = var.identifier
  tags                                  = { Name = var.identifier }
  region                                = var.region
  engine                                = var.engine
  engine_version                        = var.engine_version
  master_username                       = var.master_username
  master_password                       = var.master_password
  manage_master_user_password           = var.manage_master_user_password
  database_name                         = var.database_name
  port                                  = var.port
  storage_encrypted                     = true
  kms_key_id                            = var.kms_key_id
  storage_type                          = var.cluster_config.storage_type
  db_subnet_group_name                  = local.db_subnet_group_name
  db_cluster_parameter_group_name       = var.cluster_config.parameter_group_family != null ? aws_rds_cluster_parameter_group.this[0].name : var.cluster_config.cluster_parameter_group_name
  vpc_security_group_ids                = var.vpc_security_group_ids
  deletion_protection                   = var.deletion_protection
  skip_final_snapshot                   = var.skip_final_snapshot
  final_snapshot_identifier             = var.skip_final_snapshot ? null : var.final_snapshot_identifier
  backup_retention_period               = var.backup_retention_period
  preferred_backup_window               = var.backup_window
  preferred_maintenance_window          = var.maintenance_window
  apply_immediately                     = var.apply_immediately
  enabled_cloudwatch_logs_exports       = var.enabled_cloudwatch_logs_exports
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_kms_key_id       = var.performance_insights_enabled ? var.performance_insights_kms_key_id : null
  performance_insights_retention_period = var.performance_insights_enabled ? var.performance_insights_retention_period : null
  copy_tags_to_snapshot                 = var.copy_tags_to_snapshot
  snapshot_identifier                   = var.snapshot_identifier
  iam_database_authentication_enabled   = var.iam_database_authentication_enabled
  allow_major_version_upgrade           = var.allow_major_version_upgrade
  delete_automated_backups              = var.delete_automated_backups
  network_type                          = var.network_type
  master_user_secret_kms_key_id         = var.master_user_secret_kms_key_id
  global_cluster_identifier             = var.cluster_config.global_cluster_identifier
  replication_source_identifier         = var.cluster_config.replication_source_identifier
  backtrack_window                      = var.cluster_config.backtrack_window
  enable_http_endpoint                  = var.cluster_config.enable_http_endpoint
  iam_roles                             = var.cluster_config.iam_roles
  availability_zones                    = var.cluster_config.availability_zones
  source_region                         = var.cluster_config.source_region
  dynamic "serverlessv2_scaling_configuration" {
    for_each = var.cluster_config.serverlessv2_scaling_configuration != null ? [var.cluster_config.serverlessv2_scaling_configuration] : []
    content {
      min_capacity = serverlessv2_scaling_configuration.value.min_capacity
      max_capacity = serverlessv2_scaling_configuration.value.max_capacity
    }
  }
  dynamic "restore_to_point_in_time" {
    for_each = var.cluster_config.restore_to_point_in_time != null ? [var.cluster_config.restore_to_point_in_time] : []
    content {
      source_cluster_identifier  = restore_to_point_in_time.value.source_cluster_identifier
      restore_type               = restore_to_point_in_time.value.restore_type
      restore_to_time            = restore_to_point_in_time.value.restore_to_time
      use_latest_restorable_time = restore_to_point_in_time.value.use_latest_restorable_time
    }
  }
}

resource "aws_rds_cluster_instance" "this" {
  for_each                              = var.cluster_config != null ? var.cluster_config.instances : {}
  identifier                            = "${var.identifier}-${each.key}"
  cluster_identifier                    = aws_rds_cluster.this[0].id
  tags                                  = { Name = "${var.identifier}-${each.key}" }
  region                                = var.region
  engine                                = var.engine
  engine_version                        = var.engine_version
  instance_class                        = each.value.instance_class != null ? each.value.instance_class : var.cluster_config.default_instance_class
  db_subnet_group_name                  = local.db_subnet_group_name
  db_parameter_group_name               = var.create_parameter_group != null ? aws_db_parameter_group.this[0].name : each.value.parameter_group_name
  publicly_accessible                   = each.value.publicly_accessible != null ? each.value.publicly_accessible : var.publicly_accessible
  apply_immediately                     = var.apply_immediately
  auto_minor_version_upgrade            = each.value.auto_minor_version_upgrade != null ? each.value.auto_minor_version_upgrade : var.auto_minor_version_upgrade
  availability_zone                     = each.value.availability_zone
  promotion_tier                        = each.value.promotion_tier
  monitoring_interval                   = var.enhanced_monitoring_interval
  monitoring_role_arn                   = var.monitoring_role_arn
  performance_insights_enabled          = each.value.performance_insights_enabled != null ? each.value.performance_insights_enabled : var.performance_insights_enabled
  performance_insights_kms_key_id       = (each.value.performance_insights_enabled != null ? each.value.performance_insights_enabled : var.performance_insights_enabled) ? var.performance_insights_kms_key_id : null
  performance_insights_retention_period = (each.value.performance_insights_enabled != null ? each.value.performance_insights_enabled : var.performance_insights_enabled) ? var.performance_insights_retention_period : null
  ca_cert_identifier                    = var.ca_cert_identifier
  preferred_backup_window               = each.value.preferred_backup_window
  preferred_maintenance_window          = each.value.preferred_maintenance_window
  copy_tags_to_snapshot                 = each.value.copy_tags_to_snapshot != null ? each.value.copy_tags_to_snapshot : var.copy_tags_to_snapshot
}
