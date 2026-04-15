variable "access_logging" {
  description = "S3 server access logging configuration. The target bucket must use AES256 and allow logging.s3.amazonaws.com to PutObject."
  type = object({
    target_bucket = string
    target_prefix = string
  })
  default = null
}

variable "analytics_configurations" {
  description = "Map of S3 analytics configurations, keyed by configuration name. Each entry creates one aws_s3_bucket_analytics_configuration resource."
  type = map(object({
    filter = optional(object({
      prefix = optional(string)
      tags   = optional(map(string))
    }))
    storage_class_analysis = optional(object({
      destination_bucket_arn        = string
      destination_bucket_account_id = optional(string)
      destination_prefix            = optional(string)
      format                        = optional(string)
      output_schema_version         = optional(string)
    }))
  }))
  default = {}
}

variable "bucket_key_enabled" {
  description = "Whether to use S3 Bucket Keys for SSE-KMS. Reduces KMS API call costs. Only applies when sse_algorithm is 'aws:kms'."
  type        = bool
  default     = true
}

variable "bucket_name" {
  description = "The name of the S3 bucket."
  type        = string
}

variable "cors_rules" {
  description = "List of CORS rules. When empty, no CORS configuration is created. Up to 100 rules supported."
  type = list(object({
    id              = optional(string)
    allowed_headers = optional(list(string))
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = optional(list(string))
    max_age_seconds = optional(number)
  }))
  default = []
}

variable "create_kms_key" {
  description = "When set, a KMS key and alias are created and used for bucket encryption. Overrides kms_master_key_id."
  type = object({
    alias                   = string
    description             = optional(string)
    deletion_window_in_days = optional(number)
    enable_key_rotation     = optional(bool)
    multi_region            = optional(bool)
    policy                  = optional(string)
  })
  default = null
}

variable "force_destroy" {
  description = "Allow destroying the bucket even if it contains objects. Should remain false in production."
  type        = bool
  default     = false
}

variable "intelligent_tiering_configurations" {
  description = "Map of S3 Intelligent-Tiering configurations, keyed by configuration name. Each entry creates one aws_s3_bucket_intelligent_tiering_configuration resource."
  type = map(object({
    status = string
    filter = optional(object({
      prefix = optional(string)
      tags   = optional(map(string))
    }))
    tierings = list(object({
      access_tier = string
      days        = number
    }))
  }))
  default = {}
}

variable "inventory_configurations" {
  description = "Map of S3 inventory configurations, keyed by configuration name. Each entry creates one aws_s3_bucket_inventory resource."
  type = map(object({
    included_object_versions = string
    schedule_frequency       = string
    enabled                  = optional(bool)
    optional_fields          = optional(list(string))
    filter_prefix            = optional(string)
    destination_bucket_arn   = string
    destination_format       = string
    destination_account_id   = optional(string)
    destination_prefix       = optional(string)
    destination_encryption = optional(object({
      sse_kms_key_id = optional(string)
    }))
  }))
  default = {}
}

variable "kms_master_key_id" {
  description = "ARN or ID of an existing KMS key to use for SSE-KMS encryption. Ignored when create_kms_key is set. When both are null and sse_algorithm is 'aws:kms', the AWS-managed aws/s3 key is used."
  type        = string
  default     = null
}

variable "lifecycle_rules" {
  description = "List of lifecycle rules to apply to the bucket."
  type = list(object({
    id     = string
    status = string
    filter = optional(object({
      prefix                   = optional(string)
      object_size_greater_than = optional(number)
      object_size_less_than    = optional(number)
      tag = optional(object({
        key   = string
        value = string
      }))
      and = optional(object({
        prefix                   = optional(string)
        object_size_greater_than = optional(number)
        object_size_less_than    = optional(number)
        tags                     = optional(map(string))
      }))
    }))
    abort_incomplete_multipart_upload_days = optional(number)
    expiration = optional(object({
      days                         = optional(number)
      date                         = optional(string)
      expired_object_delete_marker = optional(bool)
    }))
    transitions = optional(list(object({
      days          = optional(number)
      date          = optional(string)
      storage_class = string
    })))
    noncurrent_version_expiration = optional(object({
      noncurrent_days           = number
      newer_noncurrent_versions = optional(number)
    }))
    noncurrent_version_transitions = optional(list(object({
      noncurrent_days           = number
      storage_class             = string
      newer_noncurrent_versions = optional(number)
    })))
  }))
  default = []
}

variable "metric_configurations" {
  description = "Map of S3 CloudWatch request metrics configurations, keyed by configuration name (max 64 chars). Each entry creates one aws_s3_bucket_metric resource."
  type = map(object({
    filter = optional(object({
      access_point = optional(string)
      prefix       = optional(string)
      tags         = optional(map(string))
    }))
  }))
  default = {}
}

variable "notifications" {
  description = "S3 event notification configuration. Supports Lambda, SQS, and SNS destinations. When null, no notification configuration is created."
  type = object({
    lambda_functions = optional(list(object({
      id                  = optional(string)
      lambda_function_arn = string
      events              = list(string)
      filter_prefix       = optional(string)
      filter_suffix       = optional(string)
    })), [])
    queues = optional(list(object({
      id            = optional(string)
      queue_arn     = string
      events        = list(string)
      filter_prefix = optional(string)
      filter_suffix = optional(string)
    })), [])
    topics = optional(list(object({
      id            = optional(string)
      topic_arn     = string
      events        = list(string)
      filter_prefix = optional(string)
      filter_suffix = optional(string)
    })), [])
  })
  default = null
}

variable "object_lock" {
  description = "Object Lock configuration. When set, Object Lock is enabled on the bucket. Versioning must also be enabled. The default_retention rule is optional — it sets the default retention applied to new objects."
  type = object({
    default_retention = optional(object({
      mode  = string
      days  = optional(number)
      years = optional(number)
    }))
  })
  default = null
}

variable "policy" {
  description = "JSON-encoded bucket policy to attach to the bucket. When null, no bucket policy is created."
  type        = string
  default     = null
}

variable "replication" {
  description = "Cross-account S3 replication configuration. When set, an IAM role and replication configuration are created. Versioning must be enabled."
  type = object({
    role_name          = string
    source_kms_key_arn = optional(string)
    rules = list(object({
      id                      = optional(string)
      status                  = optional(string)
      destination_bucket_arn  = string
      destination_account_id  = string
      destination_kms_key_arn = optional(string)
      owner                   = optional(string)
      storage_class           = optional(string)
    }))
  })
  default = null
}

variable "request_payer" {
  description = "Specifies who pays for downloads and requests. Valid values: 'BucketOwner', 'Requester'. When null, no request payment configuration is created."
  type        = string
  default     = null

  validation {
    condition     = var.request_payer == null || contains(["BucketOwner", "Requester"], var.request_payer)
    error_message = "request_payer must be 'BucketOwner' or 'Requester'."
  }
}

variable "sse_algorithm" {
  description = "Server-side encryption algorithm. Use 'aws:kms' for CMK encryption or 'AES256' for SSE-S3. Note: S3 server access log delivery requires 'AES256' on the target bucket."
  type        = string
  default     = "aws:kms"

  validation {
    condition     = contains(["aws:kms", "AES256"], var.sse_algorithm)
    error_message = "sse_algorithm must be 'aws:kms' or 'AES256'."
  }
}

variable "transfer_acceleration" {
  description = "Transfer acceleration state for the bucket. Valid values: 'Enabled', 'Suspended'. When null, no accelerate configuration is created. Not supported in cn-north-1 or us-gov-west-1."
  type        = string
  default     = null

  validation {
    condition     = var.transfer_acceleration == null || contains(["Enabled", "Suspended"], var.transfer_acceleration)
    error_message = "transfer_acceleration must be 'Enabled' or 'Suspended'."
  }
}

variable "versioning_status" {
  description = "Versioning state of the bucket. Must be 'Enabled', 'Suspended', or 'Disabled'."
  type        = string
}
