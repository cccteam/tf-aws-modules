variable "cloudwatch_log_group_name" {
  type        = string
  description = "(Optional) Cloudwatch Log Group name for SSM patching"
  default     = "tf-ssm-patching-logs"
}

variable "cloudwatch_output_enabled" {
  type        = bool
  description = "(Optional) - Opt out: Whether to enable Cloudwatch logging. Default to 'true'."
  default     = true
}

variable "create_iam_role" {
  type        = bool
  description = "(Optional) Whether to create an IAM role for SSM. Defaults to 'false'."
  default     = false
}

variable "maintenance_task_name" {
  type        = string
  description = "(Required) Name of SSM Maintenance Task"
}

variable "maintenance_window_name" {
  type        = string
  description = "(Required) Name of SSM Maintenance Window"
}

variable "maintenance_window_target_name" {
  type        = string
  description = "(Required) Name of SSM Maintenance Window Target Group"
}

variable "max_patching_concurrency" {
  type        = number
  description = "(Optional) Number of concurrent patching tasks"
  default     = 1
}

variable "max_patching_errors" {
  type        = number
  description = "(Optional) Number of max errors before job failure"
  default     = 0
}

variable "patch_baseline_task_document_name" {
  type        = string
  description = "(Optional) The Run command document name for the AWS RunBaseline task"
  default     = "AWS-RunPatchBaseline"
}

variable "patching_ec2_instance_ids" {
  type        = list(string)
  description = "(Required) List of EC2 Instance IDs to add to patching"
}

variable "patching_priority" {
  type        = number
  description = "(Optional) Priority of patching job.  Default is 0 (highest)"
  default     = 0
}

variable "patching_schedule" {
  type        = string
  description = <<-EOT
  (Required) Schedule expression for patching schedule.
  Examples:
  cron: "cron(0 3 ? * SUN *)" - Runs every Sunday at 3am UTC
  rate: "rate(5 minutes)" - runs every 5 minutes.
  EOT
}

variable "run_command_timeout_seconds" {
  type        = number
  description = "(Optional) Number of seconds before timeout for SSM Run Command. Defaults to 3600 (1 hour)."
  default     = 3600
}

variable "ssm_create_task" {
  type        = bool
  description = "(Optional) Whether to create the SSM Maintenance Task. Default is 'true'."
  default     = true
}

variable "ssm_iam_policy_name" {
  type        = string
  description = "(Conditionally required) Name of SSM IAM Policy to be assigned to SSM IAM Role when create_iam_role is true."
  default     = ""
  validation {
    condition = (
      var.create_iam_role == false ||
      (
        var.create_iam_role == true &&
        length(trimspace(var.ssm_iam_policy_name)) > 0
      )
    )
    error_message = "ssm_iam_policy_name must be set when create_iam_role is true."
  }
}

variable "ssm_iam_role_name" {
  type        = string
  description = "(Conditionally required) Name of IAM Role to be assigned to SSM Maintenance Tasks"
  default     = null
  validation {
    condition     = var.create_iam_role == false || (var.ssm_iam_role_name != null && trimspace(var.ssm_iam_role_name) != "")
    error_message = "ssm_iam_role_name must be set to a non-empty value when create_iam_role is true."
  }
}

variable "ssm_operation_directive" {
  type        = string
  description = "(Required) Operation directive for SSM Task. Options are 'Scan' or 'Install'"
  validation {
    condition     = contains(["Scan", "Install"], var.ssm_operation_directive)
    error_message = "ssm_operation_directive must be one of: Scan, Install."
  }
}

variable "ssm_reboot_directive" {
  type        = string
  description = "(Required) Reboot operation directive for SSM Task. Options are 'RebootIfNeeded' or 'NoReboot'"
  validation {
    condition     = contains(["RebootIfNeeded", "NoReboot"], var.ssm_reboot_directive)
    error_message = "ssm_reboot_directive must be one of: RebootIfNeeded, NoReboot."
  }
}

variable "ssm_service_role_arn" {
  type        = string
  description = "(Optional) ARN of IAM Service role that can assume SSM"
  default     = ""
}
