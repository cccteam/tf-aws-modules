<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [aws_iam_policy.permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ec2_maint_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ssm_managed_core](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_ssm_maintenance_window.maintenance_window](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_maintenance_window) | resource |
| [aws_ssm_maintenance_window_target.instance_ids](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_maintenance_window_target) | resource |
| [aws_ssm_maintenance_window_task.baseline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_maintenance_window_task) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_cloudwatch_log_group_name"></a> [cloudwatch\_log\_group\_name](#input\_cloudwatch\_log\_group\_name) | (Optional) Cloudwatch Log Group name for SSM patching | `string` | `"tf-ssm-patching-logs"` | no |
| <a name="input_cloudwatch_output_enabled"></a> [cloudwatch\_output\_enabled](#input\_cloudwatch\_output\_enabled) | (Optional) - Opt out: Whether to enable Cloudwatch logging. Default to 'true'. | `bool` | `true` | no |
| <a name="input_create_iam_role"></a> [create\_iam\_role](#input\_create\_iam\_role) | (Optional) Whether to create an IAM role for SSM. Defaults to 'false'. | `bool` | `false` | no |
| <a name="input_maintenance_task_name"></a> [maintenance\_task\_name](#input\_maintenance\_task\_name) | (Required) Name of SSM Maintenance Task | `string` | n/a | yes |
| <a name="input_maintenance_window_name"></a> [maintenance\_window\_name](#input\_maintenance\_window\_name) | (Required) Name of SSM Maintenance Window | `string` | n/a | yes |
| <a name="input_maintenance_window_target_name"></a> [maintenance\_window\_target\_name](#input\_maintenance\_window\_target\_name) | (Required) Name of SSM Maintenance Window Target Group | `string` | n/a | yes |
| <a name="input_max_patching_concurrency"></a> [max\_patching\_concurrency](#input\_max\_patching\_concurrency) | (Optional) Number of concurrent patching tasks | `number` | `1` | no |
| <a name="input_max_patching_errors"></a> [max\_patching\_errors](#input\_max\_patching\_errors) | (Optional) Number of max errors before job failure | `number` | `0` | no |
| <a name="input_patch_baseline_task_document_name"></a> [patch\_baseline\_task\_document\_name](#input\_patch\_baseline\_task\_document\_name) | (Optional) The Run command document name for the AWS RunBaseline task | `string` | `"AWS-RunPatchBaseline"` | no |
| <a name="input_patching_ec2_instance_ids"></a> [patching\_ec2\_instance\_ids](#input\_patching\_ec2\_instance\_ids) | (Required) List of EC2 Instance IDs to add to patching | `list(string)` | n/a | yes |
| <a name="input_patching_priority"></a> [patching\_priority](#input\_patching\_priority) | (Optional) Priority of patching job.  Default is 0 (highest) | `number` | `0` | no |
| <a name="input_patching_schedule"></a> [patching\_schedule](#input\_patching\_schedule) | (Required) Schedule expression for patching schedule.<br/>Examples:<br/>cron: "cron(0 3 ? * SUN *)" - Runs every Sunday at 3am UTC<br/>rate: "rate(5 minutes)" - runs every 5 minutes. | `string` | n/a | yes |
| <a name="input_run_command_timeout_seconds"></a> [run\_command\_timeout\_seconds](#input\_run\_command\_timeout\_seconds) | (Optional) Number of seconds before timeout for SSM Run Command. Defaults to 3600 (1 hour). | `number` | `3600` | no |
| <a name="input_ssm_create_task"></a> [ssm\_create\_task](#input\_ssm\_create\_task) | (Optional) Whether to create the SSM Maintenance Task. Default is 'true'. | `bool` | `true` | no |
| <a name="input_ssm_iam_policy_name"></a> [ssm\_iam\_policy\_name](#input\_ssm\_iam\_policy\_name) | (Conditionally required) Name of SSM IAM Policy to be assigned to SSM IAM Role when create\_iam\_role is true. | `string` | `""` | no |
| <a name="input_ssm_iam_role_name"></a> [ssm\_iam\_role\_name](#input\_ssm\_iam\_role\_name) | (Conditionally required) Name of IAM Role to be assigned to SSM Maintenance Tasks | `string` | `null` | no |
| <a name="input_ssm_operation_directive"></a> [ssm\_operation\_directive](#input\_ssm\_operation\_directive) | (Required) Operation directive for SSM Task. Options are 'Scan' or 'Install' | `string` | n/a | yes |
| <a name="input_ssm_reboot_directive"></a> [ssm\_reboot\_directive](#input\_ssm\_reboot\_directive) | (Required) Reboot operation directive for SSM Task. Options are 'RebootIfNeeded' or 'NoReboot' | `string` | n/a | yes |
| <a name="input_ssm_service_role_arn"></a> [ssm\_service\_role\_arn](#input\_ssm\_service\_role\_arn) | (Optional) ARN of IAM Service role that can assume SSM | `string` | `""` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_ssm_cloudwatch_log_group_arn"></a> [ssm\_cloudwatch\_log\_group\_arn](#output\_ssm\_cloudwatch\_log\_group\_arn) | n/a |
| <a name="output_ssm_maintenance_task_service_role_arn"></a> [ssm\_maintenance\_task\_service\_role\_arn](#output\_ssm\_maintenance\_task\_service\_role\_arn) | ARN of the service role if created by module |
<!-- END_TF_DOCS -->