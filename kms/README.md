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
| [aws_kms_alias.replica](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_kms_replica_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_replica_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aliases"></a> [aliases](#input\_aliases) | (Optional) Map of aliases for the KMS key. Each entry must specify exactly one of 'name' or 'name\_prefix', and the value must begin with 'alias/'. | <pre>map(object({<br/>    name        = optional(string)<br/>    name_prefix = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_bypass_policy_lockout_safety_check"></a> [bypass\_policy\_lockout\_safety\_check](#input\_bypass\_policy\_lockout\_safety\_check) | (Optional) Whether to bypass the key policy lockout safety check. Setting this to true increases the risk of the key becoming unmanageable. Defaults to false. | `bool` | `false` | no |
| <a name="input_custom_key_store_id"></a> [custom\_key\_store\_id](#input\_custom\_key\_store\_id) | (Optional) ID of the KMS Custom Key Store where the key will be stored. When null, the key is stored in the standard AWS KMS key store. | `string` | `null` | no |
| <a name="input_customer_master_key_spec"></a> [customer\_master\_key\_spec](#input\_customer\_master\_key\_spec) | (Optional) Specifies whether the key contains a symmetric key, an asymmetric key pair, or an HMAC key. Valid values: 'SYMMETRIC\_DEFAULT', 'RSA\_2048', 'RSA\_3072', 'RSA\_4096', 'HMAC\_224', 'HMAC\_256', 'HMAC\_384', 'HMAC\_512', 'ECC\_NIST\_P256', 'ECC\_NIST\_P384', 'ECC\_NIST\_P521', 'ECC\_SECG\_P256K1', 'ECC\_NIST\_EDWARDS25519', 'ML\_DSA\_44', 'ML\_DSA\_65', 'ML\_DSA\_87', 'SM2'. Defaults to 'SYMMETRIC\_DEFAULT'. | `string` | `"SYMMETRIC_DEFAULT"` | no |
| <a name="input_deletion_window_in_days"></a> [deletion\_window\_in\_days](#input\_deletion\_window\_in\_days) | (Optional) The waiting period in days before deleting the key after it has been scheduled for deletion. Valid values: 7-30. Defaults to 30. | `number` | `30` | no |
| <a name="input_description"></a> [description](#input\_description) | (Optional) A description of the KMS key. | `string` | `null` | no |
| <a name="input_enable_key_rotation"></a> [enable\_key\_rotation](#input\_enable\_key\_rotation) | (Optional) Whether automatic key rotation is enabled. Supported for symmetric keys and HMAC keys. Defaults to true. | `bool` | `true` | no |
| <a name="input_is_enabled"></a> [is\_enabled](#input\_is\_enabled) | (Optional) Whether the key is enabled. Defaults to true. | `bool` | `true` | no |
| <a name="input_key_usage"></a> [key\_usage](#input\_key\_usage) | (Optional) Intended use of the key. Valid values: 'ENCRYPT\_DECRYPT', 'SIGN\_VERIFY', 'GENERATE\_VERIFY\_MAC'. Defaults to 'ENCRYPT\_DECRYPT'. | `string` | `"ENCRYPT_DECRYPT"` | no |
| <a name="input_multi_region"></a> [multi\_region](#input\_multi\_region) | (Optional) Whether the KMS key is a multi-region primary key. Defaults to false. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | The name used for the KMS key Name tag. | `string` | n/a | yes |
| <a name="input_policy"></a> [policy](#input\_policy) | (Optional) A valid JSON key policy document. When null, AWS uses the default key policy. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | (Optional) AWS region to deploy resources into. When null, the provider's default region is used. | `string` | `null` | no |
| <a name="input_replica_keys"></a> [replica\_keys](#input\_replica\_keys) | (Optional) Map of replica key configurations to create in other AWS regions. Only valid when multi\_region is true. Each key in the map is a logical name for the replica. | <pre>map(object({<br/>    region                             = string<br/>    description                        = optional(string)<br/>    deletion_window_in_days            = optional(number)<br/>    is_enabled                         = optional(bool)<br/>    policy                             = optional(string)<br/>    bypass_policy_lockout_safety_check = optional(bool)<br/>    aliases = optional(map(object({<br/>      name        = optional(string)<br/>      name_prefix = optional(string)<br/>    })), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_rotation_period_in_days"></a> [rotation\_period\_in\_days](#input\_rotation\_period\_in\_days) | (Optional) The number of days between each automatic rotation. Valid values: 90–2560. Only applies when enable\_key\_rotation is true. When null, AWS uses the default rotation period (365 days). | `number` | `null` | no |
| <a name="input_xks_key_id"></a> [xks\_key\_id](#input\_xks\_key\_id) | (Optional) Identifies the external key that serves as key material for the KMS key in an external key store. Only applicable when custom\_key\_store\_id refers to an external key store. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aliases"></a> [aliases](#output\_aliases) | Map of alias logical keys from the `aliases` input map to their ARNs. Empty when no aliases are configured. |
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the KMS key. |
| <a name="output_id"></a> [id](#output\_id) | Globally unique identifier (key ID) of the KMS key. |
| <a name="output_key_rotation_enabled"></a> [key\_rotation\_enabled](#output\_key\_rotation\_enabled) | Whether automatic key rotation is enabled for the KMS key. |
| <a name="output_replica_key_aliases"></a> [replica\_key\_aliases](#output\_replica\_key\_aliases) | Map of '<logical\_name>/<alias>' to alias ARNs for all replica key aliases. Empty when no replica\_keys are configured. |
| <a name="output_replica_key_arns"></a> [replica\_key\_arns](#output\_replica\_key\_arns) | Map of replica key logical names to their ARNs. Empty when no replica\_keys are configured. |
| <a name="output_replica_key_ids"></a> [replica\_key\_ids](#output\_replica\_key\_ids) | Map of replica key logical names to their key IDs. Empty when no replica\_keys are configured. |
<!-- END_TF_DOCS -->