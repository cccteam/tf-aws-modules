locals {
  kms_key_id = var.create_kms_key != null ? aws_kms_key.this[0].arn : var.kms_master_key_id
}
