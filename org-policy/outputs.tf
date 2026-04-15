output "policy_id" {
  description = "The ID of the organizational policy."
  value       = aws_organizations_policy.this.id
}

output "policy_arn" {
  description = "The ARN of the organizational policy."
  value       = aws_organizations_policy.this.arn
}
