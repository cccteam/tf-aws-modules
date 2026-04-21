variable "data_protection_policy_document" {
  description = "(Optional) JSON-encoded data protection policy document to mask sensitive data in the log group. See https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/mask-sensitive-log-data-start.html."
  type        = string
  default     = null
}

variable "deletion_protection_enabled" {
  description = "(Optional) Whether deletion protection is enabled. Once enabled, switching back to false requires an explicit false rather than removing this argument."
  type        = bool
  default     = false
}

variable "kms_key_id" {
  description = "(Optional) The ARN of the KMS key to use for encrypting log data."
  type        = string
  default     = null
}

variable "log_group_class" {
  description = "(Optional) The log class of the log group. Possible values are: STANDARD, INFREQUENT_ACCESS, or DELIVERY. Ignored when set to DELIVERY — retention_in_days is forcibly set to 2 by AWS."
  type        = string
  default     = null
  validation {
    condition     = var.log_group_class == null || contains(["STANDARD", "INFREQUENT_ACCESS", "DELIVERY"], var.log_group_class)
    error_message = "log_group_class must be one of: STANDARD, INFREQUENT_ACCESS, DELIVERY."
  }
}

variable "metric_filters" {
  description = "(Optional) List of metric filters to extract CloudWatch metrics from log events."
  type = list(object({
    name                      = string
    pattern                   = string
    apply_on_transformed_logs = optional(bool)
    metric_transformation = object({
      name          = string
      namespace     = string
      value         = string
      default_value = optional(string)
      dimensions    = optional(map(string))
      unit          = optional(string)
    })
  }))
  default = []
}

variable "name" {
  description = "(Optional, forces new resource) The name of the CloudWatch log group. Conflicts with name_prefix. If omitted, Terraform will assign a random, unique name."
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "(Optional, forces new resource) Creates a unique name beginning with the specified prefix. Conflicts with name."
  type        = string
  default     = null
}

variable "query_definitions" {
  description = "(Optional) List of CloudWatch Logs Insights saved query definitions to associate with the log group."
  type = list(object({
    name            = string
    query_string    = string
    log_group_names = optional(list(string))
  }))
  default = []
}

variable "region" {
  description = "(Optional) Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "resource_policy" {
  description = "(Optional) Resource policy to attach to the log group. Provide policy_document as a JSON-encoded IAM policy. Set policy_name to create an account-scoped policy (limited to 10 per region); omit it to create a resource-scoped policy attached to this log group."
  type = object({
    policy_document = string
    policy_name     = optional(string)
  })
  default = null
}

variable "retention_in_days" {
  description = "(Optional) The number of days to retain log events. Possible values are: 0 (never expire), 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653."
  type        = number
  default     = 90
  validation {
    condition     = contains([0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653], var.retention_in_days)
    error_message = "retention_in_days must be one of: 0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653."
  }
}

variable "skip_destroy" {
  description = "(Optional) Set to true to retain the log group and its contents on destroy, removing it only from Terraform state."
  type        = bool
  default     = false
}

variable "subscription_filter" {
  description = "(Optional) Subscription filter to forward matching log events to a Kinesis stream or Lambda function."
  type = object({
    name                      = string
    destination_arn           = string
    filter_pattern            = string
    role_arn                  = optional(string)
    distribution              = optional(string)
    emit_system_fields        = optional(list(string))
    apply_on_transformed_logs = optional(bool)
  })
  default = null
  validation {
    condition     = var.subscription_filter == null || var.subscription_filter.distribution == null || contains(["Random", "ByLogStream"], var.subscription_filter.distribution)
    error_message = "subscription_filter.distribution must be one of: Random, ByLogStream."
  }
}
