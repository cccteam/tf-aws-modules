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
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_capacity_provider.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_capacity_provider) | resource |
| [aws_ecs_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_cluster_capacity_providers.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster_capacity_providers) | resource |
| [aws_service_discovery_private_dns_namespace.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_private_dns_namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_autoscaling_capacity_providers"></a> [autoscaling\_capacity\_providers](#input\_autoscaling\_capacity\_providers) | (Optional) Map of Auto Scaling capacity providers to create, keyed by capacity provider name. Each entry creates one aws\_ecs\_capacity\_provider resource. | <pre>map(object({<br/>    auto_scaling_group_arn         = string<br/>    managed_termination_protection = optional(string)<br/>    managed_scaling = optional(object({<br/>      instance_warmup_period    = optional(number)<br/>      maximum_scaling_step_size = optional(number)<br/>      minimum_scaling_step_size = optional(number)<br/>      status                    = optional(string)<br/>      target_capacity           = optional(number)<br/>    }))<br/>    managed_draining = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_capacity_providers"></a> [capacity\_providers](#input\_capacity\_providers) | (Optional) List of capacity providers to associate with the cluster. Valid values include 'FARGATE', 'FARGATE\_SPOT', and any custom Auto Scaling capacity provider names. | `list(string)` | `[]` | no |
| <a name="input_container_insights"></a> [container\_insights](#input\_container\_insights) | (Optional) Enables or disables CloudWatch Container Insights for the cluster. Valid values: 'enabled', 'disabled'. When null, no setting is applied. | `string` | `null` | no |
| <a name="input_create_cloudwatch_log_group"></a> [create\_cloudwatch\_log\_group](#input\_create\_cloudwatch\_log\_group) | (Optional) When set, a CloudWatch log group is created for ECS execute command logging. | <pre>object({<br/>    name              = string<br/>    retention_in_days = optional(number)<br/>    kms_key_id        = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_default_capacity_provider_strategy"></a> [default\_capacity\_provider\_strategy](#input\_default\_capacity\_provider\_strategy) | (Optional) Default capacity provider strategy for the cluster. Applied when tasks are launched without specifying a strategy. | <pre>object({<br/>    base              = optional(number)<br/>    weight            = optional(number)<br/>    capacity_provider = string<br/>  })</pre> | `null` | no |
| <a name="input_execute_command_configuration"></a> [execute\_command\_configuration](#input\_execute\_command\_configuration) | (Optional) ECS Exec and managed storage configuration for the cluster. When set, enables ECS Exec and/or Fargate ephemeral storage encryption. Within managed\_storage\_configuration, omitting kms\_key\_id or fargate\_ephemeral\_storage\_kms\_key\_id causes AWS to use the AWS-managed key (aws/ecs) — encryption is always applied. | <pre>object({<br/>    kms_key_id = optional(string)<br/>    logging    = optional(string)<br/>    log_configuration = optional(object({<br/>      cloud_watch_encryption_enabled = optional(bool)<br/>      cloud_watch_log_group_name     = optional(string)<br/>      s3_bucket_name                 = optional(string)<br/>      s3_bucket_encryption_enabled   = optional(bool)<br/>      s3_key_prefix                  = optional(string)<br/>    }))<br/>    managed_storage_configuration = optional(object({<br/>      fargate_ephemeral_storage_kms_key_id = optional(string)<br/>      kms_key_id                           = optional(string)<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) Name of the ECS cluster. Used as a prefix for related resource names. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | (Optional) AWS region to deploy the ECS cluster into. When null, the provider's default region is used. | `string` | `null` | no |
| <a name="input_service_connect_defaults"></a> [service\_connect\_defaults](#input\_service\_connect\_defaults) | (Optional) ARN of the default Service Connect namespace for the cluster. Tasks that don't specify a namespace will use this one. When null, no default is set. | `string` | `null` | no |
| <a name="input_service_discovery_namespace"></a> [service\_discovery\_namespace](#input\_service\_discovery\_namespace) | (Optional) When set, creates a private Route 53 DNS namespace for service discovery within the specified VPC. | <pre>object({<br/>    name        = string<br/>    description = optional(string)<br/>    vpc_id      = string<br/>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudwatch_log_group_arn"></a> [cloudwatch\_log\_group\_arn](#output\_cloudwatch\_log\_group\_arn) | ARN of the CloudWatch log group created for ECS Exec logging. Null when create\_cloudwatch\_log\_group is not set. |
| <a name="output_cloudwatch_log_group_name"></a> [cloudwatch\_log\_group\_name](#output\_cloudwatch\_log\_group\_name) | Name of the CloudWatch log group created for ECS Exec logging. Null when create\_cloudwatch\_log\_group is not set. |
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | ARN of the ECS cluster. |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | ID of the ECS cluster. |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Name of the ECS cluster. |
| <a name="output_service_discovery_namespace_arn"></a> [service\_discovery\_namespace\_arn](#output\_service\_discovery\_namespace\_arn) | ARN of the service discovery private DNS namespace. Null when service\_discovery\_namespace is not set. |
| <a name="output_service_discovery_namespace_hosted_zone"></a> [service\_discovery\_namespace\_hosted\_zone](#output\_service\_discovery\_namespace\_hosted\_zone) | Hosted zone ID of the service discovery private DNS namespace. Null when service\_discovery\_namespace is not set. |
| <a name="output_service_discovery_namespace_id"></a> [service\_discovery\_namespace\_id](#output\_service\_discovery\_namespace\_id) | ID of the service discovery private DNS namespace. Null when service\_discovery\_namespace is not set. |
<!-- END_TF_DOCS -->