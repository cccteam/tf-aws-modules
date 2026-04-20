variable "allocated_storage" {
  description = "(Required when cluster_config is null) The allocated storage size in gibibytes."
  type        = number
  default     = null
}

variable "allow_major_version_upgrade" {
  description = "(Optional) Whether to allow major engine version upgrades when changing the engine version."
  type        = bool
  default     = null
}

variable "apply_immediately" {
  description = "(Optional) Whether to apply changes immediately or defer them to the next maintenance window."
  type        = bool
  default     = false
}

variable "auto_minor_version_upgrade" {
  description = "(Optional) Whether to automatically apply minor engine version upgrades during the maintenance window."
  type        = bool
  default     = true
}

variable "availability_zone" {
  description = "(Optional) The AZ in which to create the instance. Only applies when cluster_config is null."
  type        = string
  default     = null
}

variable "backup_retention_period" {
  description = "(Optional) The number of days to retain automated backups. Must be between 0 and 35."
  type        = number
  default     = 7
  validation {
    condition     = var.backup_retention_period >= 0 && var.backup_retention_period <= 35
    error_message = "backup_retention_period must be between 0 and 35."
  }
}

variable "backup_window" {
  description = "(Optional) The daily time range during which automated backups are created. Format: 'hh24:mi-hh24:mi' (e.g., '03:00-04:00')."
  type        = string
  default     = null
}

variable "blue_green_update" {
  description = "(Optional) Enables low-downtime updates using RDS Blue/Green deployments. Supported for MySQL, MariaDB, and PostgreSQL. Only applies when cluster_config is null."
  type = object({
    enabled = bool
  })
  default = null
}

variable "ca_cert_identifier" {
  description = "(Optional) The identifier of the CA certificate to use for the instance or cluster instances."
  type        = string
  default     = null
}

variable "character_set_name" {
  description = "(Optional) The character set name for Oracle and SQL Server engines. Only applies when cluster_config is null."
  type        = string
  default     = null
}

variable "cluster_config" {
  description = "(Optional) When set, creates an Aurora cluster (aws_rds_cluster + aws_rds_cluster_instance) instead of a standard RDS instance. The engine must be 'aurora-mysql' or 'aurora-postgresql'."
  type = object({
    default_instance_class       = string
    storage_type                 = optional(string) # set to "aurora-iopt1" for Aurora I/O Optimized
    cluster_parameter_group_name = optional(string)
    parameter_group_family       = optional(string)
    parameters = optional(list(object({
      name         = string
      value        = string
      apply_method = optional(string)
    })), [])
    global_cluster_identifier     = optional(string)
    replication_source_identifier = optional(string)
    backtrack_window              = optional(number)
    enable_http_endpoint          = optional(bool)
    iam_roles                     = optional(set(string))
    availability_zones            = optional(list(string))
    source_region                 = optional(string)
    serverlessv2_scaling_configuration = optional(object({
      min_capacity = number
      max_capacity = number
    }))
    restore_to_point_in_time = optional(object({
      source_cluster_identifier  = optional(string)
      restore_type               = optional(string)
      restore_to_time            = optional(string)
      use_latest_restorable_time = optional(bool)
    }))
    instances = map(object({
      instance_class               = optional(string)
      publicly_accessible          = optional(bool)
      auto_minor_version_upgrade   = optional(bool)
      performance_insights_enabled = optional(bool)
      parameter_group_name         = optional(string)
      availability_zone            = optional(string)
      promotion_tier               = optional(number)
      preferred_backup_window      = optional(string)
      preferred_maintenance_window = optional(string)
      copy_tags_to_snapshot        = optional(bool)
    }))
  })
  default = null
}

variable "copy_tags_to_snapshot" {
  description = "(Optional) Whether to copy all resource tags to snapshots."
  type        = bool
  default     = true
}

variable "create_option_group" {
  description = "(Optional) When set, creates an aws_db_option_group. Only applies when cluster_config is null. Primarily used for MySQL and Oracle engines."
  type = object({
    engine_name          = string
    major_engine_version = string
    description          = optional(string, "Managed by Terraform")
    options = optional(list(object({
      option_name = string
      port        = optional(number)
      option_settings = optional(list(object({
        name  = string
        value = string
      })), [])
    })), [])
  })
  default = null
}

variable "create_parameter_group" {
  description = "(Optional) When set, creates an aws_db_parameter_group. For Aurora, this is used as the instance-level parameter group."
  type = object({
    family      = string
    description = optional(string, "Managed by Terraform")
    parameters = optional(list(object({
      name         = string
      value        = string
      apply_method = optional(string)
    })), [])
  })
  default = null
}

variable "create_subnet_group" {
  description = "(Optional) Whether to create an aws_db_subnet_group from subnet_ids. Set to false and provide db_subnet_group_name to use an existing group."
  type        = bool
  default     = true
}

variable "database_insights_mode" {
  description = "(Optional) The mode of Database Insights to enable. Valid values: 'standard', 'advanced'. Only applies when cluster_config is null."
  type        = string
  default     = null
  validation {
    condition     = var.database_insights_mode == null || contains(["standard", "advanced"], var.database_insights_mode)
    error_message = "database_insights_mode must be 'standard' or 'advanced'."
  }
}

variable "database_name" {
  description = "(Optional) The name of the initial database to create."
  type        = string
  default     = null
}

variable "db_parameter_group_name" {
  description = "(Optional) Name of an existing DB parameter group. Used when create_parameter_group is null."
  type        = string
  default     = null
}

variable "db_subnet_group_name" {
  description = "(Optional) Name of an existing DB subnet group. Used when create_subnet_group is false."
  type        = string
  default     = null
}

variable "dedicated_log_volume" {
  description = "(Optional) Use a dedicated log volume (DLV) for the DB instance. Requires Provisioned IOPS. Only applies when cluster_config is null."
  type        = bool
  default     = null
}

variable "delete_automated_backups" {
  description = "(Optional) Whether to remove automated backups immediately after the DB instance is deleted. Defaults to true in AWS."
  type        = bool
  default     = null
}

variable "deletion_protection" {
  description = "(Optional) Whether to enable deletion protection."
  type        = bool
  default     = true
}

variable "domain" {
  description = "(Optional) The ID of the Active Directory domain to join. Conflicts with domain_fqdn. Only applies when cluster_config is null."
  type        = string
  default     = null
}

variable "domain_auth_secret_arn" {
  description = "(Optional) The ARN of the Secrets Manager secret with self managed Active Directory credentials. Conflicts with domain and domain_iam_role_name. Only applies when cluster_config is null."
  type        = string
  default     = null
}

variable "domain_dns_ips" {
  description = "(Optional) The IPv4 DNS IP addresses of your primary and secondary self managed Active Directory domain controllers. Conflicts with domain and domain_iam_role_name. Only applies when cluster_config is null."
  type        = list(string)
  default     = null
}

variable "domain_fqdn" {
  description = "(Optional) The fully qualified domain name of a self managed Active Directory. Conflicts with domain and domain_iam_role_name. Only applies when cluster_config is null."
  type        = string
  default     = null
}

variable "domain_iam_role_name" {
  description = "(Optional) The name of the IAM role to use when making API calls to the Directory Service. Conflicts with domain_fqdn. Only applies when cluster_config is null."
  type        = string
  default     = null
}

variable "domain_ou" {
  description = "(Optional) The self managed Active Directory organizational unit to join. Conflicts with domain and domain_iam_role_name. Only applies when cluster_config is null."
  type        = string
  default     = null
}

variable "enabled_cloudwatch_logs_exports" {
  description = "(Optional) List of log types to export to CloudWatch Logs. Valid values depend on the engine (e.g., 'audit', 'error', 'general', 'slowquery' for MySQL; 'postgresql', 'upgrade' for PostgreSQL)."
  type        = list(string)
  default     = []
}

variable "engine" {
  description = "The database engine. For standard RDS: 'mysql', 'postgres', 'mariadb', 'oracle-ee', 'sqlserver-ex', etc. For Aurora: 'aurora-mysql' or 'aurora-postgresql'."
  type        = string
}

variable "engine_lifecycle_support" {
  description = "(Optional) The life cycle type for the DB instance. Valid values: 'open-source-rds-extended-support', 'open-source-rds-extended-support-disabled'. Only applies when cluster_config is null."
  type        = string
  default     = null
}

variable "engine_version" {
  description = "(Optional) The engine version. When null, AWS uses the default version for the engine."
  type        = string
  default     = null
}

variable "enhanced_monitoring_interval" {
  description = "(Optional) The interval in seconds at which to collect enhanced monitoring metrics. Valid values: 0 (disabled), 1, 5, 10, 15, 30, 60."
  type        = number
  default     = 0
  validation {
    condition     = contains([0, 1, 5, 10, 15, 30, 60], var.enhanced_monitoring_interval)
    error_message = "enhanced_monitoring_interval must be one of: 0, 1, 5, 10, 15, 30, 60."
  }
}

variable "final_snapshot_identifier" {
  description = "(Optional) The snapshot identifier for the final snapshot. Used when skip_final_snapshot is false. When null, defaults to the identifier."
  type        = string
  default     = null
}

variable "iam_database_authentication_enabled" {
  description = "(Optional) Whether to enable IAM database authentication."
  type        = bool
  default     = null
}

variable "identifier" {
  description = "The identifier used to name the RDS instance, cluster, and all associated resources."
  type        = string
}

variable "instance_class" {
  description = "(Required when cluster_config is null) The instance class. e.g., 'db.t3.micro'. Not used for Aurora clusters (use cluster_config.default_instance_class instead)."
  type        = string
  default     = null
}

variable "iops" {
  description = "(Optional) The amount of provisioned IOPS. Required for 'io1' and 'io2', optional for 'gp3'. Only applies when cluster_config is null."
  type        = number
  default     = null
}

variable "kms_key_id" {
  description = "(Optional) ARN of an existing KMS key for storage encryption. When null, AWS uses the default aws/rds managed key."
  type        = string
  default     = null
}

variable "license_model" {
  description = "(Optional) The license model. Required for certain engines (e.g., 'license-included' for Oracle or SQL Server). Only applies when cluster_config is null."
  type        = string
  default     = null
}

variable "maintenance_window" {
  description = "(Optional) The weekly time range during which system maintenance can occur. Format: 'ddd:hh24:mi-ddd:hh24:mi' (e.g., 'sun:05:00-sun:06:00')."
  type        = string
  default     = null
}

variable "manage_master_user_password" {
  description = "(Optional) When true, AWS manages the master password in Secrets Manager. Mutually exclusive with master_password."
  type        = bool
  default     = null
}

variable "master_password" {
  description = "(Optional) The master password. Sensitive. Mutually exclusive with manage_master_user_password."
  type        = string
  default     = null
  sensitive   = true
}

variable "master_user_secret_kms_key_id" {
  description = "(Optional) The ARN of the KMS key used to encrypt the master user password in Secrets Manager. Only applies when manage_master_user_password is true."
  type        = string
  default     = null
}

variable "master_username" {
  description = "The master username for the database."
  type        = string
}

variable "max_allocated_storage" {
  description = "(Optional) When set, enables storage autoscaling up to this value in gibibytes. Only applies when cluster_config is null."
  type        = number
  default     = null
}

variable "monitoring_role_arn" {
  description = "(Optional) ARN of the IAM role for enhanced monitoring. Required when enhanced_monitoring_interval > 0."
  type        = string
  default     = null
}

variable "multi_az" {
  description = "(Optional) Whether to enable Multi-AZ deployment. Only applies when cluster_config is null."
  type        = bool
  default     = false
}

variable "nchar_character_set_name" {
  description = "(Optional) The national character set name for Oracle engines. Only applies when cluster_config is null."
  type        = string
  default     = null
}

variable "network_type" {
  description = "(Optional) The network type for the instance or cluster. Valid values: 'IPV4', 'DUAL'."
  type        = string
  default     = null
  validation {
    condition     = var.network_type == null || contains(["IPV4", "DUAL"], var.network_type)
    error_message = "network_type must be 'IPV4' or 'DUAL'."
  }
}

variable "option_group_name" {
  description = "(Optional) Name of an existing option group. Used when create_option_group is null and cluster_config is null."
  type        = string
  default     = null
}

variable "performance_insights_enabled" {
  description = "(Optional) Whether to enable Performance Insights."
  type        = bool
  default     = false
}

variable "performance_insights_kms_key_id" {
  description = "(Optional) ARN of the KMS key to encrypt Performance Insights data. When null, the AWS-managed key is used."
  type        = string
  default     = null
}

variable "performance_insights_retention_period" {
  description = "(Optional) The number of days to retain Performance Insights data. Valid values: 7, 731, or a multiple of 31 (up to 731). Defaults to 7 when null."
  type        = number
  default     = null
}

variable "port" {
  description = "(Optional) The port on which the database accepts connections. When null, the default port for the engine is used."
  type        = number
  default     = null
}

variable "publicly_accessible" {
  description = "(Optional) Whether the instance or cluster instances are publicly accessible."
  type        = bool
  default     = false
}

variable "region" {
  description = "(Optional) AWS region to deploy resources into. When null, the provider's default region is used."
  type        = string
  default     = null
}

variable "replica_mode" {
  description = "(Optional) Specifies whether the replica is in 'mounted' or 'open-read-only' mode. Only supported for Oracle instances. Only applies when cluster_config is null."
  type        = string
  default     = null
  validation {
    condition     = var.replica_mode == null || contains(["mounted", "open-read-only"], var.replica_mode)
    error_message = "replica_mode must be 'mounted' or 'open-read-only'."
  }
}

variable "replicate_source_db" {
  description = "(Optional) The identifier of the source DB instance to create a read replica from. Only applies when cluster_config is null."
  type        = string
  default     = null
}

variable "restore_to_point_in_time" {
  description = "(Optional) Restore the DB instance to a point in time. Conflicts with snapshot_identifier. Only applies when cluster_config is null."
  type = object({
    source_db_instance_identifier            = optional(string)
    restore_time                             = optional(string)
    use_latest_restorable_time               = optional(bool)
    source_db_instance_automated_backups_arn = optional(string)
    source_dbi_resource_id                   = optional(string)
  })
  default = null
}

variable "skip_destroy" {
  description = "(Optional) When true, the parameter group(s) and option group are not deleted on destroy. Useful when they may still be associated with a DB instance outside of Terraform."
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "(Optional) Whether to skip the final snapshot when deleting the instance or cluster."
  type        = bool
  default     = false
}

variable "snapshot_identifier" {
  description = "(Optional) The snapshot identifier to restore the instance or cluster from. Conflicts with restore_to_point_in_time."
  type        = string
  default     = null
}

variable "storage_throughput" {
  description = "(Optional) The storage throughput in MiB/s. Only valid for storage_type 'gp3'. Only applies when cluster_config is null."
  type        = number
  default     = null
}

variable "storage_type" {
  description = "(Optional) The storage type. Valid values: 'gp2', 'gp3', 'io1', 'io2', 'standard'. Only applies when cluster_config is null."
  type        = string
  default     = "gp3"
  validation {
    condition     = contains(["gp2", "gp3", "io1", "io2", "standard"], var.storage_type)
    error_message = "storage_type must be one of 'gp2', 'gp3', 'io1', 'io2', or 'standard'."
  }
}

variable "subnet_ids" {
  description = "List of subnet IDs for the DB subnet group. Required when create_subnet_group is true."
  type        = list(string)
  default     = []
}

variable "timezone" {
  description = "(Optional) The time zone of the DB instance. Required for SQL Server. Only applies when cluster_config is null."
  type        = string
  default     = null
}

variable "upgrade_storage_config" {
  description = "(Optional) Whether to upgrade the storage file system configuration on the read replica. Can only be used with replicate_source_db. Only applies when cluster_config is null."
  type        = bool
  default     = null
}

variable "vpc_security_group_ids" {
  description = "(Optional) List of security group IDs to associate with the instance or cluster."
  type        = list(string)
  default     = []
}
