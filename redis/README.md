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
| [aws_elasticache_parameter_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group) | resource |
| [aws_elasticache_replication_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | (Optional) Whether modifications are applied immediately or during the next maintenance window. Defaults to false. | `bool` | `false` | no |
| <a name="input_at_rest_encryption_enabled"></a> [at\_rest\_encryption\_enabled](#input\_at\_rest\_encryption\_enabled) | (Optional) Whether to enable encryption at rest. Defaults to true. | `bool` | `true` | no |
| <a name="input_auth_token"></a> [auth\_token](#input\_auth\_token) | (Optional) Password used to access a password-protected server. Must be 16–128 printable ASCII characters. Only valid when transit\_encryption\_enabled is true. | `string` | `null` | no |
| <a name="input_auth_token_update_strategy"></a> [auth\_token\_update\_strategy](#input\_auth\_token\_update\_strategy) | (Optional) Strategy for updating the auth token. Valid values: 'SET', 'ROTATE', 'DELETE'. Only applies when auth\_token is set. Defaults to 'ROTATE' for zero-downtime rotation. | `string` | `"ROTATE"` | no |
| <a name="input_auto_minor_version_upgrade"></a> [auto\_minor\_version\_upgrade](#input\_auto\_minor\_version\_upgrade) | (Optional) Whether minor engine upgrades are applied automatically during the maintenance window. Defaults to true. | `bool` | `true` | no |
| <a name="input_automatic_failover_enabled"></a> [automatic\_failover\_enabled](#input\_automatic\_failover\_enabled) | (Optional) Whether a read-only replica is automatically promoted to primary if the existing primary fails. Must be true when num\_node\_groups > 1. Defaults to false. | `bool` | `false` | no |
| <a name="input_create_parameter_group"></a> [create\_parameter\_group](#input\_create\_parameter\_group) | (Optional) When set, an ElastiCache parameter group is created and used for the replication group. Mutually exclusive with parameter\_group\_name. | <pre>object({<br/>    name        = string<br/>    family      = string<br/>    description = optional(string)<br/>    parameters = optional(list(object({<br/>      name  = string<br/>      value = string<br/>    })))<br/>  })</pre> | `null` | no |
| <a name="input_create_subnet_group"></a> [create\_subnet\_group](#input\_create\_subnet\_group) | (Optional) When set, an ElastiCache subnet group is created and used for the replication group. Mutually exclusive with subnet\_group\_name. | <pre>object({<br/>    name        = string<br/>    subnet_ids  = list(string)<br/>    description = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | A user-created description for the replication group. | `string` | n/a | yes |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | (Optional) Redis engine version (e.g., '7.1'). When null, AWS uses the default version. | `string` | `null` | no |
| <a name="input_final_snapshot_identifier"></a> [final\_snapshot\_identifier](#input\_final\_snapshot\_identifier) | (Optional) Name of a final snapshot to create before the replication group is deleted. When null, no final snapshot is taken. | `string` | `null` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | (Optional) ARN of the KMS key used for at-rest encryption. When null and at\_rest\_encryption\_enabled is true, the AWS-managed key is used. | `string` | `null` | no |
| <a name="input_log_delivery_configuration"></a> [log\_delivery\_configuration](#input\_log\_delivery\_configuration) | (Optional) List of log delivery configurations. Supports 'slow-log' and 'engine-log' log types delivered to CloudWatch Logs or Kinesis Firehose. | <pre>list(object({<br/>    destination      = string<br/>    destination_type = string<br/>    log_format       = string<br/>    log_type         = string<br/>  }))</pre> | `null` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | (Optional) Weekly maintenance window. Format: ddd:hh24:mi-ddd:hh24:mi (e.g., 'sun:05:00-sun:06:00'). | `string` | `null` | no |
| <a name="input_multi_az_enabled"></a> [multi\_az\_enabled](#input\_multi\_az\_enabled) | (Optional) Whether to enable Multi-AZ support. Requires automatic\_failover\_enabled to be true. Defaults to false. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | The replication group identifier. Must be 1–40 characters, start with a lowercase letter, and contain only lowercase alphanumeric characters and hyphens. | `string` | n/a | yes |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | Instance class for the replication group nodes (e.g., 'cache.t3.micro'). | `string` | n/a | yes |
| <a name="input_notification_topic_arn"></a> [notification\_topic\_arn](#input\_notification\_topic\_arn) | (Optional) ARN of an SNS topic to receive ElastiCache notifications. | `string` | `null` | no |
| <a name="input_num_node_groups"></a> [num\_node\_groups](#input\_num\_node\_groups) | (Optional) Number of node groups (shards). Setting this to more than 1 enables Redis Cluster Mode. Defaults to 1. | `number` | `1` | no |
| <a name="input_parameter_group_name"></a> [parameter\_group\_name](#input\_parameter\_group\_name) | (Optional) Name of an existing ElastiCache parameter group to associate with the replication group. Used when create\_parameter\_group is null. | `string` | `null` | no |
| <a name="input_port"></a> [port](#input\_port) | (Optional) Port number for the cache nodes. Defaults to 6379. | `number` | `6379` | no |
| <a name="input_replicas_per_node_group"></a> [replicas\_per\_node\_group](#input\_replicas\_per\_node\_group) | (Optional) Number of replica nodes in each node group. Valid values: 0–5. Defaults to 1. | `number` | `1` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | (Optional) List of security group IDs to associate with the replication group. | `list(string)` | `[]` | no |
| <a name="input_snapshot_retention_limit"></a> [snapshot\_retention\_limit](#input\_snapshot\_retention\_limit) | (Optional) Number of days to retain automatic snapshots. Set to 0 to disable. Defaults to 0. | `number` | `0` | no |
| <a name="input_snapshot_window"></a> [snapshot\_window](#input\_snapshot\_window) | (Optional) Daily time range (UTC) for automated snapshots. Format: hh24:mi-hh24:mi (e.g., '05:00-06:00'). | `string` | `null` | no |
| <a name="input_subnet_group_name"></a> [subnet\_group\_name](#input\_subnet\_group\_name) | (Optional) Name of an existing ElastiCache subnet group. Used when create\_subnet\_group is null. | `string` | `null` | no |
| <a name="input_transit_encryption_enabled"></a> [transit\_encryption\_enabled](#input\_transit\_encryption\_enabled) | (Optional) Whether to enable TLS encryption in transit. Defaults to true. | `bool` | `true` | no |
| <a name="input_transit_encryption_mode"></a> [transit\_encryption\_mode](#input\_transit\_encryption\_mode) | (Optional) TLS mode for in-transit encryption. Valid values: 'preferred', 'required'. Requires Redis 7.0.5+ and transit\_encryption\_enabled to be true. When null, the AWS provider default is used. | `string` | `null` | no |
| <a name="input_user_group_ids"></a> [user\_group\_ids](#input\_user\_group\_ids) | (Optional) List of User Group IDs to associate with the replication group. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the ElastiCache replication group. |
| <a name="output_cluster_enabled"></a> [cluster\_enabled](#output\_cluster\_enabled) | Whether cluster mode is enabled for the replication group. |
| <a name="output_configuration_endpoint_address"></a> [configuration\_endpoint\_address](#output\_configuration\_endpoint\_address) | Configuration endpoint address of the replication group. Only populated when cluster mode is enabled (num\_node\_groups > 1). |
| <a name="output_engine_version_actual"></a> [engine\_version\_actual](#output\_engine\_version\_actual) | Actual running Redis engine version. May differ from var.engine\_version because ElastiCache determines the full patch version. |
| <a name="output_id"></a> [id](#output\_id) | ID of the ElastiCache replication group. |
| <a name="output_member_clusters"></a> [member\_clusters](#output\_member\_clusters) | Identifiers of all cache clusters that are part of the replication group. |
| <a name="output_parameter_group_name"></a> [parameter\_group\_name](#output\_parameter\_group\_name) | Name of the ElastiCache parameter group associated with the replication group. Null when neither create\_parameter\_group nor parameter\_group\_name is set. |
| <a name="output_primary_endpoint_address"></a> [primary\_endpoint\_address](#output\_primary\_endpoint\_address) | Address of the primary node endpoint. Only populated when cluster mode is disabled (num\_node\_groups = 1). |
| <a name="output_reader_endpoint_address"></a> [reader\_endpoint\_address](#output\_reader\_endpoint\_address) | Address of the reader endpoint for the replication group. Only populated when cluster mode is disabled (num\_node\_groups = 1). |
| <a name="output_subnet_group_name"></a> [subnet\_group\_name](#output\_subnet\_group\_name) | Name of the ElastiCache subnet group associated with the replication group. Null when neither create\_subnet\_group nor subnet\_group\_name is set. |
<!-- END_TF_DOCS -->
