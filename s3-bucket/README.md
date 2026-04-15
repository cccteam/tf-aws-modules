<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.replication](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_kms_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_accelerate_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_accelerate_configuration) | resource |
| [aws_s3_bucket_analytics_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_analytics_configuration) | resource |
| [aws_s3_bucket_cors_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_cors_configuration) | resource |
| [aws_s3_bucket_intelligent_tiering_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_intelligent_tiering_configuration) | resource |
| [aws_s3_bucket_inventory.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_inventory) | resource |
| [aws_s3_bucket_lifecycle_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_logging.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_metric.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_metric) | resource |
| [aws_s3_bucket_notification.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_s3_bucket_object_lock_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object_lock_configuration) | resource |
| [aws_s3_bucket_ownership_controls.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_replication_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_replication_configuration) | resource |
| [aws_s3_bucket_request_payment_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_request_payment_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_logging"></a> [access\_logging](#input\_access\_logging) | S3 server access logging configuration. The target bucket must use AES256 and allow logging.s3.amazonaws.com to PutObject. | <pre>object({<br/>    target_bucket = string<br/>    target_prefix = string<br/>  })</pre> | `null` | no |
| <a name="input_analytics_configurations"></a> [analytics\_configurations](#input\_analytics\_configurations) | Map of S3 analytics configurations, keyed by configuration name. Each entry creates one aws\_s3\_bucket\_analytics\_configuration resource. | <pre>map(object({<br/>    filter = optional(object({<br/>      prefix = optional(string)<br/>      tags   = optional(map(string))<br/>    }))<br/>    storage_class_analysis = optional(object({<br/>      destination_bucket_arn        = string<br/>      destination_bucket_account_id = optional(string)<br/>      destination_prefix            = optional(string)<br/>      format                        = optional(string)<br/>      output_schema_version         = optional(string)<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_bucket_key_enabled"></a> [bucket\_key\_enabled](#input\_bucket\_key\_enabled) | Whether to use S3 Bucket Keys for SSE-KMS. Reduces KMS API call costs. Only applies when sse\_algorithm is 'aws:kms'. | `bool` | `true` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name of the S3 bucket. | `string` | n/a | yes |
| <a name="input_cors_rules"></a> [cors\_rules](#input\_cors\_rules) | List of CORS rules. When empty, no CORS configuration is created. Up to 100 rules supported. | <pre>list(object({<br/>    id              = optional(string)<br/>    allowed_headers = optional(list(string))<br/>    allowed_methods = list(string)<br/>    allowed_origins = list(string)<br/>    expose_headers  = optional(list(string))<br/>    max_age_seconds = optional(number)<br/>  }))</pre> | `[]` | no |
| <a name="input_create_kms_key"></a> [create\_kms\_key](#input\_create\_kms\_key) | When set, a KMS key and alias are created and used for bucket encryption. Overrides kms\_master\_key\_id. | <pre>object({<br/>    alias                   = string<br/>    description             = optional(string)<br/>    deletion_window_in_days = optional(number)<br/>    enable_key_rotation     = optional(bool)<br/>    multi_region            = optional(bool)<br/>    policy                  = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Allow destroying the bucket even if it contains objects. Should remain false in production. | `bool` | `false` | no |
| <a name="input_intelligent_tiering_configurations"></a> [intelligent\_tiering\_configurations](#input\_intelligent\_tiering\_configurations) | Map of S3 Intelligent-Tiering configurations, keyed by configuration name. Each entry creates one aws\_s3\_bucket\_intelligent\_tiering\_configuration resource. | <pre>map(object({<br/>    status = string<br/>    filter = optional(object({<br/>      prefix = optional(string)<br/>      tags   = optional(map(string))<br/>    }))<br/>    tierings = list(object({<br/>      access_tier = string<br/>      days        = number<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_inventory_configurations"></a> [inventory\_configurations](#input\_inventory\_configurations) | Map of S3 inventory configurations, keyed by configuration name. Each entry creates one aws\_s3\_bucket\_inventory resource. | <pre>map(object({<br/>    included_object_versions = string<br/>    schedule_frequency       = string<br/>    enabled                  = optional(bool)<br/>    optional_fields          = optional(list(string))<br/>    filter_prefix            = optional(string)<br/>    destination_bucket_arn   = string<br/>    destination_format       = string<br/>    destination_account_id   = optional(string)<br/>    destination_prefix       = optional(string)<br/>    destination_encryption = optional(object({<br/>      sse_kms_key_id = optional(string)<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_kms_master_key_id"></a> [kms\_master\_key\_id](#input\_kms\_master\_key\_id) | ARN or ID of an existing KMS key to use for SSE-KMS encryption. Ignored when create\_kms\_key is set. When both are null and sse\_algorithm is 'aws:kms', the AWS-managed aws/s3 key is used. | `string` | `null` | no |
| <a name="input_lifecycle_rules"></a> [lifecycle\_rules](#input\_lifecycle\_rules) | List of lifecycle rules to apply to the bucket. | <pre>list(object({<br/>    id     = string<br/>    status = string<br/>    filter = optional(object({<br/>      prefix                   = optional(string)<br/>      object_size_greater_than = optional(number)<br/>      object_size_less_than    = optional(number)<br/>      tag = optional(object({<br/>        key   = string<br/>        value = string<br/>      }))<br/>      and = optional(object({<br/>        prefix                   = optional(string)<br/>        object_size_greater_than = optional(number)<br/>        object_size_less_than    = optional(number)<br/>        tags                     = optional(map(string))<br/>      }))<br/>    }))<br/>    abort_incomplete_multipart_upload_days = optional(number)<br/>    expiration = optional(object({<br/>      days                         = optional(number)<br/>      date                         = optional(string)<br/>      expired_object_delete_marker = optional(bool)<br/>    }))<br/>    transitions = optional(list(object({<br/>      days          = optional(number)<br/>      date          = optional(string)<br/>      storage_class = string<br/>    })))<br/>    noncurrent_version_expiration = optional(object({<br/>      noncurrent_days           = number<br/>      newer_noncurrent_versions = optional(number)<br/>    }))<br/>    noncurrent_version_transitions = optional(list(object({<br/>      noncurrent_days           = number<br/>      storage_class             = string<br/>      newer_noncurrent_versions = optional(number)<br/>    })))<br/>  }))</pre> | `[]` | no |
| <a name="input_metric_configurations"></a> [metric\_configurations](#input\_metric\_configurations) | Map of S3 CloudWatch request metrics configurations, keyed by configuration name (max 64 chars). Each entry creates one aws\_s3\_bucket\_metric resource. | <pre>map(object({<br/>    filter = optional(object({<br/>      access_point = optional(string)<br/>      prefix       = optional(string)<br/>      tags         = optional(map(string))<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_notifications"></a> [notifications](#input\_notifications) | S3 event notification configuration. Supports Lambda, SQS, and SNS destinations. When null, no notification configuration is created. | <pre>object({<br/>    lambda_functions = optional(list(object({<br/>      id                  = optional(string)<br/>      lambda_function_arn = string<br/>      events              = list(string)<br/>      filter_prefix       = optional(string)<br/>      filter_suffix       = optional(string)<br/>    })), [])<br/>    queues = optional(list(object({<br/>      id            = optional(string)<br/>      queue_arn     = string<br/>      events        = list(string)<br/>      filter_prefix = optional(string)<br/>      filter_suffix = optional(string)<br/>    })), [])<br/>    topics = optional(list(object({<br/>      id            = optional(string)<br/>      topic_arn     = string<br/>      events        = list(string)<br/>      filter_prefix = optional(string)<br/>      filter_suffix = optional(string)<br/>    })), [])<br/>  })</pre> | `null` | no |
| <a name="input_object_lock"></a> [object\_lock](#input\_object\_lock) | Object Lock configuration. When set, Object Lock is enabled on the bucket. Versioning must also be enabled. The default\_retention rule is optional — it sets the default retention applied to new objects. | <pre>object({<br/>    default_retention = optional(object({<br/>      mode  = string<br/>      days  = optional(number)<br/>      years = optional(number)<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | JSON-encoded bucket policy to attach to the bucket. When null, no bucket policy is created. | `string` | `null` | no |
| <a name="input_replication"></a> [replication](#input\_replication) | Cross-account S3 replication configuration. When set, an IAM role and replication configuration are created. Versioning must be enabled. | <pre>object({<br/>    role_name          = string<br/>    source_kms_key_arn = optional(string)<br/>    rules = list(object({<br/>      id                      = optional(string)<br/>      status                  = optional(string)<br/>      destination_bucket_arn  = string<br/>      destination_account_id  = string<br/>      destination_kms_key_arn = optional(string)<br/>      owner                   = optional(string)<br/>      storage_class           = optional(string)<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_request_payer"></a> [request\_payer](#input\_request\_payer) | Specifies who pays for downloads and requests. Valid values: 'BucketOwner', 'Requester'. When null, no request payment configuration is created. | `string` | `null` | no |
| <a name="input_sse_algorithm"></a> [sse\_algorithm](#input\_sse\_algorithm) | Server-side encryption algorithm. Use 'aws:kms' for CMK encryption or 'AES256' for SSE-S3. Note: S3 server access log delivery requires 'AES256' on the target bucket. | `string` | `"aws:kms"` | no |
| <a name="input_transfer_acceleration"></a> [transfer\_acceleration](#input\_transfer\_acceleration) | Transfer acceleration state for the bucket. Valid values: 'Enabled', 'Suspended'. When null, no accelerate configuration is created. Not supported in cn-north-1 or us-gov-west-1. | `string` | `null` | no |
| <a name="input_versioning_status"></a> [versioning\_status](#input\_versioning\_status) | Versioning state of the bucket. Must be 'Enabled', 'Suspended', or 'Disabled'. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | The ARN of the S3 bucket. |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | The name (ID) of the S3 bucket. |
| <a name="output_bucket_regional_domain_name"></a> [bucket\_regional\_domain\_name](#output\_bucket\_regional\_domain\_name) | The bucket region-specific domain name. |
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | ARN of the KMS key used for bucket encryption. Null when sse\_algorithm is 'AES256' or the AWS-managed key is used. |
<!-- END_TF_DOCS -->