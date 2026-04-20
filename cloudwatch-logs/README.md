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
| [aws_cloudwatch_log_data_protection_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_data_protection_policy) | resource |
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_metric_filter.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_metric_filter) | resource |
| [aws_cloudwatch_log_resource_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_resource_policy) | resource |
| [aws_cloudwatch_log_subscription_filter.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_subscription_filter) | resource |
| [aws_cloudwatch_query_definition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_query_definition) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_data_protection_policy_document"></a> [data\_protection\_policy\_document](#input\_data\_protection\_policy\_document) | (Optional) JSON-encoded data protection policy document to mask sensitive data in the log group. See https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/mask-sensitive-log-data-start.html. | `string` | `null` | no |
| <a name="input_deletion_protection_enabled"></a> [deletion\_protection\_enabled](#input\_deletion\_protection\_enabled) | (Optional) Whether deletion protection is enabled. Once enabled, switching back to false requires an explicit false rather than removing this argument. | `bool` | `false` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | (Optional) The ARN of the KMS key to use for encrypting log data. | `string` | `null` | no |
| <a name="input_log_group_class"></a> [log\_group\_class](#input\_log\_group\_class) | (Optional) The log class of the log group. Possible values are: STANDARD, INFREQUENT\_ACCESS, or DELIVERY. Ignored when set to DELIVERY — retention\_in\_days is forcibly set to 2 by AWS. | `string` | `null` | no |
| <a name="input_metric_filters"></a> [metric\_filters](#input\_metric\_filters) | (Optional) List of metric filters to extract CloudWatch metrics from log events. | <pre>list(object({<br/>    name                      = string<br/>    pattern                   = string<br/>    apply_on_transformed_logs = optional(bool)<br/>    metric_transformation = object({<br/>      name          = string<br/>      namespace     = string<br/>      value         = string<br/>      default_value = optional(string)<br/>      dimensions    = optional(map(string))<br/>      unit          = optional(string)<br/>    })<br/>  }))</pre> | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | (Optional, forces new resource) The name of the CloudWatch log group. Conflicts with name\_prefix. If omitted, Terraform will assign a random, unique name. | `string` | `null` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | (Optional, forces new resource) Creates a unique name beginning with the specified prefix. Conflicts with name. | `string` | `null` | no |
| <a name="input_query_definitions"></a> [query\_definitions](#input\_query\_definitions) | (Optional) List of CloudWatch Logs Insights saved query definitions to associate with the log group. | <pre>list(object({<br/>    name            = string<br/>    query_string    = string<br/>    log_group_names = optional(list(string))<br/>  }))</pre> | `[]` | no |
| <a name="input_region"></a> [region](#input\_region) | (Optional) Region where this resource will be managed. Defaults to the Region set in the provider configuration. | `string` | `null` | no |
| <a name="input_resource_policy"></a> [resource\_policy](#input\_resource\_policy) | (Optional) Resource policy to attach to the log group. Provide policy\_document as a JSON-encoded IAM policy. Set policy\_name to create an account-scoped policy (limited to 10 per region); omit it to create a resource-scoped policy attached to this log group. | <pre>object({<br/>    policy_document = string<br/>    policy_name     = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | (Optional) The number of days to retain log events. Possible values are: 0 (never expire), 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653. | `number` | `90` | no |
| <a name="input_skip_destroy"></a> [skip\_destroy](#input\_skip\_destroy) | (Optional) Set to true to retain the log group and its contents on destroy, removing it only from Terraform state. | `bool` | `false` | no |
| <a name="input_subscription_filter"></a> [subscription\_filter](#input\_subscription\_filter) | (Optional) Subscription filter to forward matching log events to a Kinesis stream or Lambda function. | <pre>object({<br/>    name                      = string<br/>    destination_arn           = string<br/>    filter_pattern            = string<br/>    role_arn                  = optional(string)<br/>    distribution              = optional(string)<br/>    emit_system_fields        = optional(list(string))<br/>    apply_on_transformed_logs = optional(bool)<br/>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_log_group_arn"></a> [log\_group\_arn](#output\_log\_group\_arn) | The ARN of the CloudWatch log group. |
| <a name="output_log_group_name"></a> [log\_group\_name](#output\_log\_group\_name) | The name of the CloudWatch log group. |
| <a name="output_metric_filter_ids"></a> [metric\_filter\_ids](#output\_metric\_filter\_ids) | Map of metric filter names to their IDs. |
| <a name="output_query_definition_ids"></a> [query\_definition\_ids](#output\_query\_definition\_ids) | Map of query definition names to their query\_definition\_id. |
| <a name="output_resource_policy_id"></a> [resource\_policy\_id](#output\_resource\_policy\_id) | The ID of the resource policy (policy name for account-scoped, log group ARN for resource-scoped). Null when resource\_policy is not configured. |
| <a name="output_resource_policy_revision_id"></a> [resource\_policy\_revision\_id](#output\_resource\_policy\_revision\_id) | The revision ID of the resource policy. Only populated for resource-scoped policies. Null when resource\_policy is not configured. |
| <a name="output_resource_policy_scope"></a> [resource\_policy\_scope](#output\_resource\_policy\_scope) | The scope of the resource policy: ACCOUNT or RESOURCE. Null when resource\_policy is not configured. |
| <a name="output_subscription_filter_name"></a> [subscription\_filter\_name](#output\_subscription\_filter\_name) | The name of the subscription filter. Null when subscription\_filter is not configured. |
<!-- END_TF_DOCS -->