resource "aws_ecs_cluster" "this" {
  name   = var.name
  tags   = { Name = var.name }
  region = var.region
  dynamic "setting" {
    for_each = var.container_insights != null ? [var.container_insights] : []
    content {
      name  = "containerInsights"
      value = setting.value
    }
  }
  dynamic "configuration" {
    for_each = var.execute_command_configuration != null ? [var.execute_command_configuration] : []
    content {
      dynamic "execute_command_configuration" {
        for_each = [configuration.value]
        content {
          kms_key_id = execute_command_configuration.value.kms_key_id
          logging    = execute_command_configuration.value.logging
          dynamic "log_configuration" {
            for_each = execute_command_configuration.value.log_configuration != null ? [execute_command_configuration.value.log_configuration] : []
            content {
              cloud_watch_encryption_enabled = log_configuration.value.cloud_watch_encryption_enabled
              cloud_watch_log_group_name     = coalesce(log_configuration.value.cloud_watch_log_group_name, local.cloudwatch_log_group_name)
              s3_bucket_name                 = log_configuration.value.s3_bucket_name
              s3_bucket_encryption_enabled   = log_configuration.value.s3_bucket_encryption_enabled
              s3_key_prefix                  = log_configuration.value.s3_key_prefix
            }
          }
        }
      }
      dynamic "managed_storage_configuration" {
        for_each = configuration.value.managed_storage_configuration != null ? [configuration.value.managed_storage_configuration] : []
        content {
          fargate_ephemeral_storage_kms_key_id = managed_storage_configuration.value.fargate_ephemeral_storage_kms_key_id
          kms_key_id                           = managed_storage_configuration.value.kms_key_id
        }
      }
    }
  }
  dynamic "service_connect_defaults" {
    for_each = var.service_connect_defaults != null ? [var.service_connect_defaults] : []
    content {
      namespace = service_connect_defaults.value
    }
  }
}

resource "aws_cloudwatch_log_group" "this" {
  count             = var.create_cloudwatch_log_group != null ? 1 : 0
  name              = var.create_cloudwatch_log_group.name
  retention_in_days = var.create_cloudwatch_log_group.retention_in_days
  kms_key_id        = var.create_cloudwatch_log_group.kms_key_id
  tags              = { Name = var.create_cloudwatch_log_group.name }
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name       = aws_ecs_cluster.this.name
  capacity_providers = var.capacity_providers
  dynamic "default_capacity_provider_strategy" {
    for_each = var.default_capacity_provider_strategy != null ? [var.default_capacity_provider_strategy] : []
    content {
      base              = default_capacity_provider_strategy.value.base
      weight            = default_capacity_provider_strategy.value.weight
      capacity_provider = default_capacity_provider_strategy.value.capacity_provider
    }
  }
}

resource "aws_ecs_capacity_provider" "this" {
  for_each = var.autoscaling_capacity_providers
  name     = each.key
  tags     = { Name = each.key }
  auto_scaling_group_provider {
    auto_scaling_group_arn         = each.value.auto_scaling_group_arn
    managed_termination_protection = each.value.managed_termination_protection
    dynamic "managed_scaling" {
      for_each = each.value.managed_scaling != null ? [each.value.managed_scaling] : []
      content {
        instance_warmup_period    = managed_scaling.value.instance_warmup_period
        maximum_scaling_step_size = managed_scaling.value.maximum_scaling_step_size
        minimum_scaling_step_size = managed_scaling.value.minimum_scaling_step_size
        status                    = managed_scaling.value.status
        target_capacity           = managed_scaling.value.target_capacity
      }
    }
    dynamic "managed_draining" {
      for_each = each.value.managed_draining != null ? [each.value.managed_draining] : []
      content {
        status = managed_draining.value
      }
    }
  }
}

resource "aws_service_discovery_private_dns_namespace" "this" {
  count       = var.service_discovery_namespace != null ? 1 : 0
  name        = var.service_discovery_namespace.name
  description = var.service_discovery_namespace.description
  vpc         = var.service_discovery_namespace.vpc_id
  tags        = { Name = var.service_discovery_namespace.name }
}
