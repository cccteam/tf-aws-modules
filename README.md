# CCC Terraform AWS Modules

[![Infrastructure Checks](https://github.com/cccteam/tf-aws-modules/actions/workflows/infrastructure-checks.yml/badge.svg?branch=master)](https://github.com/cccteam/tf-aws-modules/actions/workflows/infrastructure-checks.yml)
[![Secret Scanning](https://github.com/cccteam/tf-aws-modules/actions/workflows/secret-scanning.yml/badge.svg?branch=master)](https://github.com/cccteam/tf-aws-modules/actions/workflows/secret-scanning.yml)

A collection of reusable OpenTofu modules for AWS infrastructure, built with security best practices, consistent style, and independent versioning.

## Modules

| Module | Description |
|--------|-------------|
| [cloudwatch-logs](/cloudwatch-logs) | CloudWatch log group with KMS encryption, retention, and data protection policy support |
| [ecs-cluster](/ecs-cluster) | ECS cluster with capacity providers, Container Insights, Service Connect, and service discovery namespace |
| [kms](/kms) | KMS key with aliases, multi-region replica keys, and external key store support |
| [org-policy](/org-policy) | AWS Organizations policy (SCP, Tag, Backup, AI Opt-Out, Chatbot) with optional target attachments |
| [rds](/rds) | RDS instance or Aurora cluster with parameter groups, subnet groups, and option groups |
| [redis](/redis) | ElastiCache Redis replication group with cluster mode, subnet groups, and parameter groups |
| [s3-bucket](/s3-bucket) | S3 bucket with encryption, versioning, lifecycle rules, replication, notifications, and all S3 sub-resources |

## Usage

Reference a module by path with a pinned commit SHA for immutability:

```hcl
module "my_bucket" {
  source = "github.com/cccteam/tf-aws-modules//s3-bucket?ref=<commit-sha>"

  bucket_name       = "my-bucket"
  versioning_status = "Enabled"
}
```

See each module's `variables.tf` for all available inputs.

## Versioning

Modules are versioned independently using [Release Please](https://github.com/googleapis/release-please). Each release is tagged in the format `module-name/vX.Y.Z` (e.g., `s3-bucket/v1.2.0`).

Commits must follow the [Conventional Commits](https://www.conventionalcommits.org/) specification to trigger automated changelog generation and version bumps.

## Development

1. Clone the repository and create a feature branch
2. Make changes following the standards below
3. Submit a pull request — CI will run formatting, linting, and security checks automatically

### Code Quality Standards

- `tofu fmt` — formatting
- `tflint` — linting and best practice validation
- `checkov` — security scanning

## License

This repository is licensed under the MIT License. See [LICENSE](LICENSE) for details.
