variable "aliases" {
  description = "(Optional) Map of aliases for the KMS key. Each entry must specify exactly one of 'name' or 'name_prefix', and the value must begin with 'alias/'."
  type = map(object({
    name        = optional(string)
    name_prefix = optional(string)
  }))
  default = {}
  validation {
    condition = alltrue([
      for k, v in var.aliases : (v.name != null) != (v.name_prefix != null)
    ])
    error_message = "Each alias must specify exactly one of 'name' or 'name_prefix'."
  }
  validation {
    condition = alltrue([
      for k, v in var.aliases : v.name != null ? startswith(v.name, "alias/") : startswith(v.name_prefix, "alias/")
    ])
    error_message = "Each alias 'name' or 'name_prefix' must begin with 'alias/'."
  }
}

variable "bypass_policy_lockout_safety_check" {
  description = "(Optional) Whether to bypass the key policy lockout safety check. Setting this to true increases the risk of the key becoming unmanageable. Defaults to false."
  type        = bool
  default     = false
}

variable "custom_key_store_id" {
  description = "(Optional) ID of the KMS Custom Key Store where the key will be stored. When null, the key is stored in the standard AWS KMS key store."
  type        = string
  default     = null
}

variable "customer_master_key_spec" {
  description = "(Optional) Specifies whether the key contains a symmetric key, an asymmetric key pair, or an HMAC key. Valid values: 'SYMMETRIC_DEFAULT', 'RSA_2048', 'RSA_3072', 'RSA_4096', 'HMAC_224', 'HMAC_256', 'HMAC_384', 'HMAC_512', 'ECC_NIST_P256', 'ECC_NIST_P384', 'ECC_NIST_P521', 'ECC_SECG_P256K1', 'ECC_NIST_ED25519', 'ML_DSA_44', 'ML_DSA_65', 'ML_DSA_87', 'SM2'. Defaults to 'SYMMETRIC_DEFAULT'."
  type        = string
  default     = "SYMMETRIC_DEFAULT"
  validation {
    condition     = contains(["SYMMETRIC_DEFAULT", "RSA_2048", "RSA_3072", "RSA_4096", "HMAC_224", "HMAC_256", "HMAC_384", "HMAC_512", "ECC_NIST_P256", "ECC_NIST_P384", "ECC_NIST_P521", "ECC_SECG_P256K1", "ECC_NIST_ED25519", "ML_DSA_44", "ML_DSA_65", "ML_DSA_87", "SM2"], var.customer_master_key_spec)
    error_message = "customer_master_key_spec must be one of: 'SYMMETRIC_DEFAULT', 'RSA_2048', 'RSA_3072', 'RSA_4096', 'HMAC_224', 'HMAC_256', 'HMAC_384', 'HMAC_512', 'ECC_NIST_P256', 'ECC_NIST_P384', 'ECC_NIST_P521', 'ECC_SECG_P256K1', 'ECC_NIST_ED25519', 'ML_DSA_44', 'ML_DSA_65', 'ML_DSA_87', 'SM2'."
  }
}

variable "deletion_window_in_days" {
  description = "(Optional) The waiting period in days before deleting the key after it has been scheduled for deletion. Valid values: 7-30. Defaults to 30."
  type        = number
  default     = 30
  validation {
    condition     = var.deletion_window_in_days >= 7 && var.deletion_window_in_days <= 30
    error_message = "deletion_window_in_days must be between 7 and 30."
  }
}

variable "description" {
  description = "(Optional) A description of the KMS key."
  type        = string
  default     = null
}

variable "enable_key_rotation" {
  description = "(Optional) Whether automatic key rotation is enabled. Supported for symmetric keys and HMAC keys. Defaults to true."
  type        = bool
  default     = true
}

variable "is_enabled" {
  description = "(Optional) Whether the key is enabled. Defaults to true."
  type        = bool
  default     = true
}

variable "key_usage" {
  description = "(Optional) Intended use of the key. Valid values: 'ENCRYPT_DECRYPT', 'SIGN_VERIFY', 'GENERATE_VERIFY_MAC'. Defaults to 'ENCRYPT_DECRYPT'."
  type        = string
  default     = "ENCRYPT_DECRYPT"
  validation {
    condition     = contains(["ENCRYPT_DECRYPT", "SIGN_VERIFY", "GENERATE_VERIFY_MAC"], var.key_usage)
    error_message = "key_usage must be 'ENCRYPT_DECRYPT', 'SIGN_VERIFY', or 'GENERATE_VERIFY_MAC'."
  }
}

variable "multi_region" {
  description = "(Optional) Whether the KMS key is a multi-region primary key. Defaults to false."
  type        = bool
  default     = false
}

variable "name" {
  description = "The name used for the KMS key Name tag."
  type        = string
}

variable "policy" {
  description = "(Optional) A valid JSON key policy document. When null, AWS uses the default key policy."
  type        = string
  default     = null
}

variable "region" {
  description = "(Optional) AWS region to deploy resources into. When null, the provider's default region is used."
  type        = string
  default     = null
}

variable "replica_keys" {
  description = "(Optional) Map of replica key configurations to create in other AWS regions. Only valid when multi_region is true. Each key in the map is a logical name for the replica."
  type = map(object({
    region                             = string
    description                        = optional(string)
    deletion_window_in_days            = optional(number)
    is_enabled                         = optional(bool)
    policy                             = optional(string)
    bypass_policy_lockout_safety_check = optional(bool)
    aliases = optional(map(object({
      name        = optional(string)
      name_prefix = optional(string)
    })), {})
  }))
  default = {}
  validation {
    condition = alltrue([
      for k, v in var.replica_keys : v.deletion_window_in_days == null || (v.deletion_window_in_days >= 7 && v.deletion_window_in_days <= 30)
    ])
    error_message = "Each replica key's deletion_window_in_days must be between 7 and 30."
  }
  validation {
    condition = alltrue(flatten([
      for k, v in var.replica_keys : [
        for ak, av in v.aliases : (av.name != null) != (av.name_prefix != null)
      ]
    ]))
    error_message = "Each replica key alias must specify exactly one of 'name' or 'name_prefix'."
  }
  validation {
    condition = alltrue(flatten([
      for k, v in var.replica_keys : [
        for ak, av in v.aliases : av.name != null ? startswith(av.name, "alias/") : startswith(av.name_prefix, "alias/")
      ]
    ]))
    error_message = "Each replica key alias 'name' or 'name_prefix' must begin with 'alias/'."
  }
}

variable "rotation_period_in_days" {
  description = "(Optional) The number of days between each automatic rotation. Valid values: 90–2560. Only applies when enable_key_rotation is true. When null, AWS uses the default rotation period (365 days)."
  type        = number
  default     = null
  validation {
    condition     = var.rotation_period_in_days == null || (var.rotation_period_in_days >= 90 && var.rotation_period_in_days <= 2560)
    error_message = "rotation_period_in_days must be between 90 and 2560."
  }
}

variable "xks_key_id" {
  description = "(Optional) Identifies the external key that serves as key material for the KMS key in an external key store. Only applicable when custom_key_store_id refers to an external key store."
  type        = string
  default     = null
}
