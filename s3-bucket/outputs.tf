output "bucket_arn" {
  description = "The ARN of the S3 bucket."
  value       = aws_s3_bucket.this.arn
}

output "bucket_id" {
  description = "The name (ID) of the S3 bucket."
  value       = aws_s3_bucket.this.id
}

output "bucket_regional_domain_name" {
  description = "The bucket region-specific domain name."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "kms_key_arn" {
  description = "ARN of the KMS key used for bucket encryption. Null when sse_algorithm is 'AES256' or the AWS-managed key is used."
  value       = var.create_kms_key != null ? aws_kms_key.this[0].arn : var.kms_master_key_id
}
