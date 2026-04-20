variable "apply_immediately" {
  description = "(Optional) Whether modifications are applied immediately or during the next maintenance window. Defaults to false."
  type        = bool
  default     = false
}

variable "cluster_mode" {
  description = "(Optional) Whether cluster mode is enabled, disabled, or compatible. Valid values: 'enabled', 'disabled', 'compatible'. When null, the AWS provider default is used."
  type        = string
  default     = null
  validation {
    condition     = var.cluster_mode == null || contains(["enabled", "disabled", "compatible"], var.cluster_mode)
    error_message = "cluster_mode must be 'enabled', 'disabled', or 'compatible'."
  }
}

variable "data_tiering_enabled" {
  description = "(Optional) Whether data tiering is enabled. Only supported on r6gd node types. Must be true when using r6gd nodes. When null, the AWS provider default is used."
  type        = bool
  default     = null
}

variable "at_rest_encryption_enabled" {
  description = "(Optional) Whether to enable encryption at rest. Defaults to true."
  type        = bool
  default     = true
}

variable "auth_token" {
  description = "(Optional) Password used to access a password-protected server. Must be 16-128 printable ASCII characters. Only valid when transit_encryption_enabled is true."
  type        = string
  default     = null
  sensitive   = true
}

variable "auth_token_update_strategy" {
  description = "(Optional) Strategy for updating the auth token. Valid values: 'SET', 'ROTATE', 'DELETE'. Only applies when auth_token is set. Defaults to 'ROTATE' for zero-downtime rotation."
  type        = string
  default     = "ROTATE"
  validation {
    condition     = contains(["SET", "ROTATE", "DELETE"], var.auth_token_update_strategy)
    error_message = "auth_token_update_strategy must be 'SET', 'ROTATE', or 'DELETE'."
  }
}

variable "auto_minor_version_upgrade" {
  description = "(Optional) Whether minor engine upgrades are applied automatically during the maintenance window. Defaults to true."
  type        = bool
  default     = true
}

variable "automatic_failover_enabled" {
  description = "(Optional) Whether a read-only replica is automatically promoted to primary if the existing primary fails. Must be true when num_node_groups > 1. Defaults to false."
  type        = bool
  default     = false
}

variable "create_parameter_group" {
  description = "(Optional) When set, an ElastiCache parameter group is created and used for the replication group. Mutually exclusive with parameter_group_name."
  type = object({
    name        = string
    family      = string
    description = optional(string)
    parameters = optional(list(object({
      name  = string
      value = string
    })))
  })
  default = null
}

variable "create_global_replication_group" {
  description = "(Optional) When set, an ElastiCache Global Replication Group is created with this replication group as the primary. Mutually exclusive with global_replication_group_id."
  type = object({
    global_replication_group_id_suffix = string
    description                        = optional(string)
    automatic_failover_enabled         = optional(bool)
    cache_node_type                    = optional(string)
    engine                             = optional(string)
    engine_version                     = optional(string)
    num_node_groups                    = optional(number)
    parameter_group_name               = optional(string)
  })
  default = null
}

variable "create_subnet_group" {
  description = "(Optional) When set, an ElastiCache subnet group is created and used for the replication group. Mutually exclusive with subnet_group_name."
  type = object({
    name        = string
    subnet_ids  = list(string)
    description = optional(string)
  })
  default = null
}

variable "description" {
  description = "A user-created description for the replication group."
  type        = string
}

variable "engine" {
  description = "(Optional) Name of the cache engine. Valid values: 'redis', 'valkey'. Defaults to 'redis'."
  type        = string
  default     = "redis"
  validation {
    condition     = contains(["redis", "valkey"], var.engine)
    error_message = "engine must be 'redis' or 'valkey'."
  }
}

variable "engine_version" {
  description = "(Optional) Redis engine version (e.g., '7.1'). See https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/supported-engine-versions.html for valid values. When null, AWS uses the default version."
  type        = string
  default     = null
}

variable "final_snapshot_identifier" {
  description = "(Optional) Name of a final snapshot to create before the replication group is deleted. When null, no final snapshot is taken."
  type        = string
  default     = null
}

variable "global_replication_group_id" {
  description = "(Optional) ID of an existing Global Replication Group to join as a secondary replication group. When set, node_type, num_node_groups, and replicas_per_node_group must not be set. Mutually exclusive with create_global_replication_group."
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "(Optional) ARN of the KMS key used for at-rest encryption. When null and at_rest_encryption_enabled is true, the AWS-managed key is used."
  type        = string
  default     = null
}

variable "ip_discovery" {
  description = "(Optional) IP version to advertise in the discovery protocol. Valid values: 'ipv4', 'ipv6'. When null, the AWS provider default is used."
  type        = string
  default     = null
  validation {
    condition     = var.ip_discovery == null || contains(["ipv4", "ipv6"], var.ip_discovery)
    error_message = "ip_discovery must be 'ipv4' or 'ipv6'."
  }
}

variable "log_delivery_configuration" {
  description = "(Optional) List of log delivery configurations. Supports 'slow-log' and 'engine-log' log types delivered to CloudWatch Logs or Kinesis Firehose."
  type = list(object({
    destination      = string
    destination_type = string
    log_format       = string
    log_type         = string
  }))
  default = null

  validation {
    condition = var.log_delivery_configuration == null || alltrue([
      for ldc in var.log_delivery_configuration :
      contains(["cloudwatch-logs", "kinesis-firehose"], ldc.destination_type)
    ])
    error_message = "log_delivery_configuration.destination_type must be 'cloudwatch-logs' or 'kinesis-firehose'."
  }

  validation {
    condition = var.log_delivery_configuration == null || alltrue([
      for ldc in var.log_delivery_configuration :
      contains(["json", "text"], ldc.log_format)
    ])
    error_message = "log_delivery_configuration.log_format must be 'json' or 'text'."
  }

  validation {
    condition = var.log_delivery_configuration == null || alltrue([
      for ldc in var.log_delivery_configuration :
      contains(["slow-log", "engine-log"], ldc.log_type)
    ])
    error_message = "log_delivery_configuration.log_type must be 'slow-log' or 'engine-log'."
  }
}

variable "maintenance_window" {
  description = "(Optional) Weekly maintenance window. Format: ddd:hh24:mi-ddd:hh24:mi (e.g., 'sun:05:00-sun:06:00'). Must be at least 60 minutes."
  type        = string
  default     = null
}

variable "multi_az_enabled" {
  description = "(Optional) Whether to enable Multi-AZ support. Requires automatic_failover_enabled to be true. Defaults to false."
  type        = bool
  default     = false
}

variable "network_type" {
  description = "(Optional) IP versions for cache cluster connections. Valid values: 'ipv4', 'ipv6', 'dual_stack'. When null, the AWS provider default is used."
  type        = string
  default     = null
  validation {
    condition     = var.network_type == null || contains(["ipv4", "ipv6", "dual_stack"], var.network_type)
    error_message = "network_type must be 'ipv4', 'ipv6', or 'dual_stack'."
  }
}

variable "name" {
  description = "The replication group identifier. Must be 1-40 characters, start with a lowercase letter, and contain only lowercase alphanumeric characters and hyphens."
  type        = string
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,39}$", var.name))
    error_message = "name must be 1-40 characters, start with a lowercase letter, and contain only lowercase alphanumeric characters and hyphens."
  }
}

variable "node_type" {
  description = "Instance class for the replication group nodes (e.g., 'cache.t3.micro'). Required unless global_replication_group_id is set. Cannot be set if global_replication_group_id is set."
  type        = string
  default     = null
}

variable "notification_topic_arn" {
  description = "(Optional) ARN of an SNS topic to receive ElastiCache notifications."
  type        = string
  default     = null
}

variable "num_cache_clusters" {
  description = "(Optional) Number of cache clusters (primary and replicas) for this replication group. Used when global_replication_group_id is set. If automatic_failover_enabled or multi_az_enabled are true, must be at least 2. Conflicts with num_node_groups and replicas_per_node_group."
  type        = number
  default     = null
}

variable "num_node_groups" {
  description = "(Optional) Number of node groups (shards). Setting this to more than 1 enables Redis Cluster Mode. Defaults to 1."
  type        = number
  default     = 1
  validation {
    condition     = var.num_node_groups >= 1 && var.num_node_groups <= 500
    error_message = "num_node_groups must be between 1 and 500."
  }
}

variable "parameter_group_name" {
  description = "(Optional) Name of an existing ElastiCache parameter group to associate with the replication group. Used when create_parameter_group is null."
  type        = string
  default     = null
}

variable "port" {
  description = "(Optional) Port number for the cache nodes. Defaults to 6379."
  type        = number
  default     = 6379
}

variable "preferred_cache_cluster_azs" {
  description = "(Optional) List of EC2 availability zones in which the cache clusters will be created. The first item will be the primary node. Ignored when updating. Conflicts with node_group_configuration."
  type        = list(string)
  default     = null
}

variable "replicas_per_node_group" {
  description = "(Optional) Number of replica nodes in each node group. Valid values: 0-5. Defaults to 1."
  type        = number
  default     = 1
  validation {
    condition     = var.replicas_per_node_group >= 0 && var.replicas_per_node_group <= 5
    error_message = "replicas_per_node_group must be between 0 and 5."
  }
}

variable "security_group_ids" {
  description = "(Optional) List of security group IDs to associate with the replication group."
  type        = list(string)
  default     = []
}

variable "snapshot_arns" {
  description = "(Optional) List of ARNs identifying Redis RDB snapshot files in Amazon S3 to restore from. Changing this forces a new resource."
  type        = list(string)
  default     = null
}

variable "snapshot_name" {
  description = "(Optional) Name of a snapshot to restore data from into the new node group. Changing this forces a new resource."
  type        = string
  default     = null
}

variable "snapshot_retention_limit" {
  description = "(Optional) Number of days to retain automatic snapshots. Set to 0 to disable automatic snapshots. Defaults to 0."
  type        = number
  default     = 0
}

variable "snapshot_window" {
  description = "(Optional) Daily time range (UTC) for automated snapshots. Format: hh24:mi-hh24:mi (e.g., '05:00-06:00'). Must be at least 60 minutes and must not conflict with the maintenance_window."
  type        = string
  default     = null
}

variable "subnet_group_name" {
  description = "(Optional) Name of an existing ElastiCache subnet group. Used when create_subnet_group is null."
  type        = string
  default     = null
}

variable "transit_encryption_enabled" {
  description = "(Optional) Whether to enable TLS encryption in transit. Defaults to true."
  type        = bool
  default     = true
}

variable "transit_encryption_mode" {
  description = "(Optional) TLS mode for in-transit encryption. Valid values: 'preferred', 'required'. Requires Redis engine 7.0.5 or later and transit_encryption_enabled to be true. When null, the AWS provider default is used."
  type        = string
  default     = null
  validation {
    condition     = var.transit_encryption_mode == null || contains(["preferred", "required"], var.transit_encryption_mode)
    error_message = "transit_encryption_mode must be 'preferred' or 'required'."
  }
}

variable "user_group_ids" {
  description = "(Optional) List of User Group IDs to associate with the replication group. AWS allows a maximum of one User Group ID."
  type        = list(string)
  default     = []
  validation {
    condition     = length(var.user_group_ids) <= 1
    error_message = "AWS allows a maximum of one User Group ID per replication group."
  }
}
