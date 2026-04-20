resource "aws_kms_key" "this" {
  region                             = var.region
  description                        = var.description
  key_usage                          = var.key_usage
  custom_key_store_id                = var.custom_key_store_id
  customer_master_key_spec           = var.customer_master_key_spec
  policy                             = var.policy
  enable_key_rotation                = var.enable_key_rotation
  rotation_period_in_days            = var.enable_key_rotation ? var.rotation_period_in_days : null
  is_enabled                         = var.is_enabled
  deletion_window_in_days            = var.deletion_window_in_days
  multi_region                       = var.multi_region
  xks_key_id                         = var.xks_key_id
  bypass_policy_lockout_safety_check = var.bypass_policy_lockout_safety_check
  tags                               = { Name = var.name }
}

resource "aws_kms_alias" "this" {
  for_each      = var.aliases
  region        = var.region
  name          = each.value.name
  name_prefix   = each.value.name_prefix
  target_key_id = aws_kms_key.this.key_id
}

resource "aws_kms_replica_key" "this" {
  for_each                           = var.replica_keys
  region                             = each.value.region
  primary_key_arn                    = aws_kms_key.this.arn
  description                        = each.value.description
  deletion_window_in_days            = each.value.deletion_window_in_days
  enabled                            = each.value.is_enabled
  policy                             = each.value.policy
  bypass_policy_lockout_safety_check = each.value.bypass_policy_lockout_safety_check
  tags                               = { Name = var.name }
}

resource "aws_kms_alias" "replica" {
  for_each      = local.replica_key_aliases
  region        = each.value.region
  name          = each.value.name
  name_prefix   = each.value.name_prefix
  target_key_id = aws_kms_replica_key.this[each.value.replica_key].key_id
}
