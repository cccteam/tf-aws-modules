resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy
  tags          = { Name = var.bucket_name }
}

resource "aws_kms_key" "this" {
  count                   = var.create_kms_key != null ? 1 : 0
  description             = var.create_kms_key.description
  deletion_window_in_days = var.create_kms_key.deletion_window_in_days
  enable_key_rotation     = var.create_kms_key.enable_key_rotation
  multi_region            = var.create_kms_key.multi_region
  policy                  = var.create_kms_key.policy
}

resource "aws_kms_alias" "this" {
  count         = var.create_kms_key != null ? 1 : 0
  name          = var.create_kms_key.alias
  target_key_id = aws_kms_key.this[0].key_id
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule { object_ownership = "BucketOwnerEnforced" } // Enforce bucket owner ownership to prevent ACLs from being applied, which can interfere with replication and other features. Requires aws_s3_bucket_public_access_block to block ACLs.
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration { status = var.versioning_status }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.sse_algorithm
      kms_master_key_id = var.sse_algorithm == "aws:kms" ? local.kms_key_id : null
    }
    bucket_key_enabled = var.sse_algorithm == "aws:kms" ? var.bucket_key_enabled : false
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count  = length(var.lifecycle_rules) > 0 ? 1 : 0
  bucket = aws_s3_bucket.this.id
  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      id     = rule.value.id
      status = rule.value.status
      dynamic "filter" {
        for_each = rule.value.filter != null ? [rule.value.filter] : []
        content {
          prefix                   = filter.value.and == null ? filter.value.prefix : null
          object_size_greater_than = filter.value.and == null ? filter.value.object_size_greater_than : null
          object_size_less_than    = filter.value.and == null ? filter.value.object_size_less_than : null
          dynamic "tag" {
            for_each = filter.value.and == null && filter.value.tag != null ? [filter.value.tag] : []
            content {
              key   = tag.value.key
              value = tag.value.value
            }
          }
          dynamic "and" {
            for_each = filter.value.and != null ? [filter.value.and] : []
            content {
              prefix                   = and.value.prefix
              object_size_greater_than = and.value.object_size_greater_than
              object_size_less_than    = and.value.object_size_less_than
              tags                     = and.value.tags
            }
          }
        }
      }
      dynamic "abort_incomplete_multipart_upload" {
        for_each = rule.value.abort_incomplete_multipart_upload_days != null ? [rule.value.abort_incomplete_multipart_upload_days] : []
        content {
          days_after_initiation = abort_incomplete_multipart_upload.value
        }
      }
      dynamic "expiration" {
        for_each = rule.value.expiration != null ? [rule.value.expiration] : []
        content {
          days                         = expiration.value.days
          date                         = expiration.value.date
          expired_object_delete_marker = expiration.value.expired_object_delete_marker
        }
      }
      dynamic "transition" {
        for_each = rule.value.transitions != null ? rule.value.transitions : []
        content {
          days          = transition.value.days
          date          = transition.value.date
          storage_class = transition.value.storage_class
        }
      }
      dynamic "noncurrent_version_expiration" {
        for_each = rule.value.noncurrent_version_expiration != null ? [rule.value.noncurrent_version_expiration] : []
        content {
          noncurrent_days           = noncurrent_version_expiration.value.noncurrent_days
          newer_noncurrent_versions = noncurrent_version_expiration.value.newer_noncurrent_versions
        }
      }
      dynamic "noncurrent_version_transition" {
        for_each = rule.value.noncurrent_version_transitions != null ? rule.value.noncurrent_version_transitions : []
        content {
          noncurrent_days           = noncurrent_version_transition.value.noncurrent_days
          storage_class             = noncurrent_version_transition.value.storage_class
          newer_noncurrent_versions = noncurrent_version_transition.value.newer_noncurrent_versions
        }
      }
    }
  }
}

resource "aws_s3_bucket_logging" "this" {
  count         = var.access_logging != null ? 1 : 0
  bucket        = aws_s3_bucket.this.id
  target_bucket = var.access_logging.target_bucket
  target_prefix = var.access_logging.target_prefix
}

resource "aws_s3_bucket_notification" "this" {
  count  = var.notifications != null ? 1 : 0
  bucket = aws_s3_bucket.this.id
  dynamic "lambda_function" {
    for_each = var.notifications != null ? var.notifications.lambda_functions : []
    content {
      id                  = lambda_function.value.id
      lambda_function_arn = lambda_function.value.lambda_function_arn
      events              = lambda_function.value.events
      filter_prefix       = lambda_function.value.filter_prefix
      filter_suffix       = lambda_function.value.filter_suffix
    }
  }
  dynamic "queue" {
    for_each = var.notifications != null ? var.notifications.queues : []
    content {
      id            = queue.value.id
      queue_arn     = queue.value.queue_arn
      events        = queue.value.events
      filter_prefix = queue.value.filter_prefix
      filter_suffix = queue.value.filter_suffix
    }
  }
  dynamic "topic" {
    for_each = var.notifications != null ? var.notifications.topics : []
    content {
      id            = topic.value.id
      topic_arn     = topic.value.topic_arn
      events        = topic.value.events
      filter_prefix = topic.value.filter_prefix
      filter_suffix = topic.value.filter_suffix
    }
  }
}

resource "aws_iam_role" "replication" {
  count = var.replication != null ? 1 : 0
  name  = var.replication.role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "replication" {
  count = var.replication != null ? 1 : 0
  name  = var.replication.role_name
  role  = aws_iam_role.replication[0].id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat(
      [
        {
          Sid    = "SourceBucketRead"
          Effect = "Allow"
          Action = [
            "s3:GetReplicationConfiguration",
            "s3:ListBucket",
          ]
          Resource = aws_s3_bucket.this.arn
        },
        {
          Sid    = "SourceObjectRead"
          Effect = "Allow"
          Action = [
            "s3:GetObjectVersionForReplication",
            "s3:GetObjectVersionAcl",
            "s3:GetObjectVersionTagging",
          ]
          Resource = "${aws_s3_bucket.this.arn}/*"
        },
        {
          Sid    = "DestinationWrite"
          Effect = "Allow"
          Action = [
            "s3:ReplicateObject",
            "s3:ReplicateDelete",
            "s3:ReplicateTags",
          ]
          Resource = [for rule in var.replication.rules : "${rule.destination_bucket_arn}/*"]
        },
      ],
      var.replication.source_kms_key_arn != null ? [
        {
          Sid      = "SourceKMSDecrypt"
          Effect   = "Allow"
          Action   = ["kms:Decrypt"]
          Resource = var.replication.source_kms_key_arn
        }
      ] : [],
      length([for r in var.replication.rules : r if r.destination_kms_key_arn != null]) > 0 ? [
        {
          Sid      = "DestinationKMSEncrypt"
          Effect   = "Allow"
          Action   = ["kms:GenerateDataKey"]
          Resource = [for r in var.replication.rules : r.destination_kms_key_arn if r.destination_kms_key_arn != null]
        }
      ] : []
    )
  })
}

resource "aws_s3_bucket_policy" "this" {
  count      = var.policy != null ? 1 : 0
  bucket     = aws_s3_bucket.this.id
  policy     = var.policy
  depends_on = [aws_s3_bucket_public_access_block.this]
}

resource "aws_s3_bucket_replication_configuration" "this" {
  depends_on = [aws_s3_bucket_versioning.this]
  count      = var.replication != null ? 1 : 0
  bucket     = aws_s3_bucket.this.id
  role       = aws_iam_role.replication[0].arn
  lifecycle {
    precondition {
      condition = !(
        var.replication.source_kms_key_arn != null &&
        can(regex("alias/aws/", var.replication.source_kms_key_arn)) &&
        anytrue([for r in var.replication.rules : r.destination_account_id != data.aws_caller_identity.current.account_id])
      )
      error_message = "AWS-managed KMS keys (alias/aws/*) cannot be used for cross-account replication. Use a customer-managed key instead."
    }
  }
  dynamic "rule" {
    for_each = var.replication.rules
    content {
      id     = rule.value.id
      status = rule.value.status
      destination {
        bucket        = rule.value.destination_bucket_arn
        storage_class = rule.value.storage_class
        account       = rule.value.destination_account_id
        dynamic "access_control_translation" {
          for_each = rule.value.owner != null ? [rule.value.owner] : []
          content {
            owner = access_control_translation.value
          }
        }
        dynamic "encryption_configuration" {
          for_each = rule.value.destination_kms_key_arn != null ? [rule.value.destination_kms_key_arn] : []
          content {
            replica_kms_key_id = encryption_configuration.value
          }
        }
      }
    }
  }
}

resource "aws_s3_bucket_accelerate_configuration" "this" {
  count  = var.transfer_acceleration != null ? 1 : 0
  bucket = aws_s3_bucket.this.id
  status = var.transfer_acceleration
}

resource "aws_s3_bucket_request_payment_configuration" "this" {
  count  = var.request_payer != null ? 1 : 0
  bucket = aws_s3_bucket.this.id
  payer  = var.request_payer
}

resource "aws_s3_bucket_cors_configuration" "this" {
  count  = length(var.cors_rules) > 0 ? 1 : 0
  bucket = aws_s3_bucket.this.id
  dynamic "cors_rule" {
    for_each = var.cors_rules
    content {
      id              = cors_rule.value.id
      allowed_headers = cors_rule.value.allowed_headers
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      expose_headers  = cors_rule.value.expose_headers
      max_age_seconds = cors_rule.value.max_age_seconds
    }
  }
}

resource "aws_s3_bucket_object_lock_configuration" "this" {
  count      = var.object_lock != null ? 1 : 0
  bucket     = aws_s3_bucket.this.id
  depends_on = [aws_s3_bucket_versioning.this]
  dynamic "rule" {
    for_each = var.object_lock.default_retention != null ? [var.object_lock.default_retention] : []
    content {
      default_retention {
        mode  = rule.value.mode
        days  = rule.value.days
        years = rule.value.years
      }
    }
  }
}

resource "aws_s3_bucket_intelligent_tiering_configuration" "this" {
  for_each = var.intelligent_tiering_configurations
  bucket   = aws_s3_bucket.this.id
  name     = each.key
  status   = each.value.status
  dynamic "filter" {
    for_each = each.value.filter != null ? [each.value.filter] : []
    content {
      prefix = filter.value.prefix
      tags   = filter.value.tags
    }
  }
  dynamic "tiering" {
    for_each = each.value.tierings
    content {
      access_tier = tiering.value.access_tier
      days        = tiering.value.days
    }
  }
}

resource "aws_s3_bucket_analytics_configuration" "this" {
  for_each = var.analytics_configurations
  bucket   = aws_s3_bucket.this.id
  name     = each.key
  dynamic "filter" {
    for_each = each.value.filter != null ? [each.value.filter] : []
    content {
      prefix = filter.value.prefix
      tags   = filter.value.tags
    }
  }
  dynamic "storage_class_analysis" {
    for_each = each.value.storage_class_analysis != null ? [each.value.storage_class_analysis] : []
    content {
      data_export {
        output_schema_version = storage_class_analysis.value.output_schema_version
        destination {
          s3_bucket_destination {
            bucket_arn        = storage_class_analysis.value.destination_bucket_arn
            bucket_account_id = storage_class_analysis.value.destination_bucket_account_id
            format            = storage_class_analysis.value.format
            prefix            = storage_class_analysis.value.destination_prefix
          }
        }
      }
    }
  }
}

resource "aws_s3_bucket_inventory" "this" {
  for_each                 = var.inventory_configurations
  bucket                   = aws_s3_bucket.this.id
  name                     = each.key
  included_object_versions = each.value.included_object_versions
  enabled                  = each.value.enabled
  optional_fields          = each.value.optional_fields
  schedule {
    frequency = each.value.schedule_frequency
  }
  dynamic "filter" {
    for_each = each.value.filter_prefix != null ? [each.value.filter_prefix] : []
    content {
      prefix = filter.value
    }
  }
  destination {
    bucket {
      bucket_arn = each.value.destination_bucket_arn
      format     = each.value.destination_format
      account_id = each.value.destination_account_id
      prefix     = each.value.destination_prefix
      dynamic "encryption" {
        for_each = each.value.destination_encryption != null ? [each.value.destination_encryption] : []
        content {
          dynamic "sse_kms" {
            for_each = encryption.value.sse_kms_key_id != null ? [encryption.value.sse_kms_key_id] : []
            content {
              key_id = sse_kms.value
            }
          }
          dynamic "sse_s3" {
            for_each = encryption.value.sse_kms_key_id == null ? [1] : []
            content {}
          }
        }
      }
    }
  }
}

resource "aws_s3_bucket_metric" "this" {
  for_each = var.metric_configurations
  bucket   = aws_s3_bucket.this.id
  name     = each.key
  dynamic "filter" {
    for_each = each.value.filter != null ? [each.value.filter] : []
    content {
      access_point = filter.value.access_point
      prefix       = filter.value.prefix
      tags         = filter.value.tags
    }
  }
}
