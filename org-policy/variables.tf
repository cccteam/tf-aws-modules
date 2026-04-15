variable "name" {
  description = "The name of the organizational policy."
  type        = string
}

variable "type" {
  description = "The type of policy. Valid values: SERVICE_CONTROL_POLICY, TAG_POLICY, BACKUP_POLICY, AISERVICES_OPT_OUT_POLICY, CHATBOT_POLICY."
  type        = string

  validation {
    condition     = contains(["SERVICE_CONTROL_POLICY", "TAG_POLICY", "BACKUP_POLICY", "AISERVICES_OPT_OUT_POLICY", "CHATBOT_POLICY"], var.type)
    error_message = "type must be one of: SERVICE_CONTROL_POLICY, TAG_POLICY, BACKUP_POLICY, AISERVICES_OPT_OUT_POLICY, CHATBOT_POLICY."
  }
}

variable "content" {
  description = "The policy content as a JSON-encoded string. Use jsonencode() in the caller."
  type        = string
}

variable "description" {
  description = "A description of the policy."
  type        = string
}

variable "skip_destroy" {
  description = "Whether to retain the policy in AWS when the resource is destroyed. Useful for policies that must persist beyond Terraform management."
  type        = bool
  default     = false
}

variable "target_ids" {
  description = "List of root IDs, OU IDs, or account IDs to attach this policy to. When empty, no attachments are created."
  type        = list(string)
  default     = []
}
