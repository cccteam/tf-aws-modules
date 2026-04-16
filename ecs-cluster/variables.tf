variable "autoscaling_capacity_providers" {
  description = "(Optional) Map of Auto Scaling capacity providers to create, keyed by capacity provider name. Each entry creates one aws_ecs_capacity_provider resource."
  type = map(object({
    auto_scaling_group_arn         = string
    managed_termination_protection = optional(string)
    managed_scaling = optional(object({
      instance_warmup_period    = optional(number)
      maximum_scaling_step_size = optional(number)
      minimum_scaling_step_size = optional(number)
      status                    = optional(string)
      target_capacity           = optional(number)
    }))
    managed_draining = optional(string)
  }))
  default = {}

  validation {
    condition = alltrue([
      for v in values(var.autoscaling_capacity_providers) :
      v.managed_termination_protection == null || contains(["ENABLED", "DISABLED"], v.managed_termination_protection)
    ])
    error_message = "managed_termination_protection must be 'ENABLED' or 'DISABLED'."
  }

  validation {
    condition = alltrue([
      for v in values(var.autoscaling_capacity_providers) :
      v.managed_draining == null || contains(["ENABLED", "DISABLED"], v.managed_draining)
    ])
    error_message = "managed_draining must be 'ENABLED' or 'DISABLED'."
  }

  validation {
    condition = alltrue([
      for v in values(var.autoscaling_capacity_providers) :
      v.managed_scaling == null || v.managed_scaling.status == null || contains(["ENABLED", "DISABLED"], v.managed_scaling.status)
    ])
    error_message = "managed_scaling.status must be 'ENABLED' or 'DISABLED'."
  }
}

variable "capacity_providers" {
  description = "(Optional) List of capacity providers to associate with the cluster. Valid values include 'FARGATE', 'FARGATE_SPOT', and any custom Auto Scaling capacity provider names."
  type        = list(string)
  default     = []
}

variable "container_insights" {
  description = "(Optional) Enables or disables CloudWatch Container Insights for the cluster. Valid values: 'enabled', 'disabled'. When null, no setting is applied."
  type        = string
  default     = null
  validation {
    condition     = var.container_insights == null || contains(["enabled", "disabled"], var.container_insights)
    error_message = "container_insights must be 'enabled' or 'disabled'."
  }
}

variable "create_cloudwatch_log_group" {
  description = "(Optional) When set, a CloudWatch log group is created for ECS execute command logging."
  type = object({
    name              = string
    retention_in_days = optional(number)
    kms_key_id        = optional(string)
  })
  default = null
}

variable "default_capacity_provider_strategy" {
  description = "(Optional) Default capacity provider strategy for the cluster. Applied when tasks are launched without specifying a strategy."
  type = object({
    base              = optional(number)
    weight            = optional(number)
    capacity_provider = string
  })
  default = null
}

variable "execute_command_configuration" {
  description = "(Optional) ECS Exec and managed storage configuration for the cluster. When set, enables ECS Exec and/or Fargate ephemeral storage encryption. Within managed_storage_configuration, omitting kms_key_id or fargate_ephemeral_storage_kms_key_id causes AWS to use the AWS-managed key (aws/ecs) — encryption is always applied."
  type = object({
    kms_key_id = optional(string)
    logging    = optional(string)
    log_configuration = optional(object({
      cloud_watch_encryption_enabled = optional(bool)
      cloud_watch_log_group_name     = optional(string)
      s3_bucket_name                 = optional(string)
      s3_bucket_encryption_enabled   = optional(bool)
      s3_key_prefix                  = optional(string)
    }))
    managed_storage_configuration = optional(object({
      fargate_ephemeral_storage_kms_key_id = optional(string)
      kms_key_id                           = optional(string)
    }))
  })
  default = null

  validation {
    condition     = var.execute_command_configuration == null || var.execute_command_configuration.logging == null || contains(["NONE", "DEFAULT", "OVERRIDE"], var.execute_command_configuration.logging)
    error_message = "execute_command_configuration.logging must be 'NONE', 'DEFAULT', or 'OVERRIDE'."
  }
}

variable "name" {
  description = "(Required) Name of the ECS cluster. Used as a prefix for related resource names."
  type        = string
}

variable "region" {
  description = "(Optional) AWS region to deploy the ECS cluster into. When null, the provider's default region is used."
  type        = string
  default     = null
}

variable "service_connect_defaults" {
  description = "(Optional) ARN of the default Service Connect namespace for the cluster. Tasks that don't specify a namespace will use this one. When null, no default is set."
  type        = string
  default     = null
}

variable "service_discovery_namespace" {
  description = "(Optional) When set, creates a private Route 53 DNS namespace for service discovery within the specified VPC."
  type = object({
    name        = string
    description = optional(string)
    vpc_id      = string
  })
  default = null
}
