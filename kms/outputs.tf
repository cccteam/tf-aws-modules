output "aliases" {
  description = "Map of alias logical keys from the `aliases` input map to their ARNs. Empty when no aliases are configured."
  value       = { for k, v in aws_kms_alias.this : k => v.arn }
}

output "arn" {
  description = "ARN of the KMS key."
  value       = aws_kms_key.this.arn
}

output "id" {
  description = "Globally unique identifier (key ID) of the KMS key."
  value       = aws_kms_key.this.key_id
}

output "key_rotation_enabled" {
  description = "Whether automatic key rotation is enabled for the KMS key."
  value       = aws_kms_key.this.enable_key_rotation
}

output "replica_key_aliases" {
  description = "Map of '<logical_name>/<alias>' to alias ARNs for all replica key aliases. Empty when no replica_keys are configured."
  value       = { for k, v in aws_kms_alias.replica : k => v.arn }
}

output "replica_key_arns" {
  description = "Map of replica key logical names to their ARNs. Empty when no replica_keys are configured."
  value       = { for k, v in aws_kms_replica_key.this : k => v.arn }
}

output "replica_key_ids" {
  description = "Map of replica key logical names to their key IDs. Empty when no replica_keys are configured."
  value       = { for k, v in aws_kms_replica_key.this : k => v.key_id }
}
