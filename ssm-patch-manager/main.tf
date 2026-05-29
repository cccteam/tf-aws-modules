resource "aws_ssm_maintenance_window" "maintenance_window" {
  name        = var.maintenance_window_name
  description = "Maintenance window for patching Windows, Linux, or MacOS EC2 instances"
  schedule    = var.patching_schedule
  duration    = 2
  cutoff      = 1

  tags = {
    Name = var.maintenance_window_name
  }
}

resource "aws_ssm_maintenance_window_task" "baseline" {
  lifecycle {
    precondition {
      condition     = var.create_iam_role || var.ssm_service_role_arn != ""
      error_message = "Either var.create_iam_role needs to be true or var.ssm_service_role_arn needs to be provided."
    }
  }
  count            = var.ssm_create_task ? 1 : 0
  name             = var.maintenance_task_name
  description      = "Default SSM Task to apply updates to Windows, Linux, or MacOS EC2 instances"
  max_concurrency  = var.max_patching_concurrency
  max_errors       = var.max_patching_errors
  priority         = var.patching_priority
  task_arn         = var.patch_baseline_task_document_name
  task_type        = "RUN_COMMAND"
  window_id        = aws_ssm_maintenance_window.maintenance_window.id
  service_role_arn = var.create_iam_role ? aws_iam_role.this[0].arn : var.ssm_service_role_arn

  task_invocation_parameters {
    run_command_parameters {
      timeout_seconds  = var.run_command_timeout_seconds
      document_version = "$LATEST"
      parameter {
        name   = "Operation"
        values = [var.ssm_operation_directive]
      }
      parameter {
        name   = "RebootOption"
        values = [var.ssm_reboot_directive]
      }
      cloudwatch_config {
        cloudwatch_log_group_name = var.cloudwatch_log_group_name
        cloudwatch_output_enabled = var.cloudwatch_output_enabled
      }
    }
  }
  targets {
    key    = "WindowTargetIds"
    values = [aws_ssm_maintenance_window_target.instance_ids[0].id]
  }
}

resource "aws_ssm_maintenance_window_target" "instance_ids" {
  count         = var.ssm_create_task ? 1 : 0
  window_id     = aws_ssm_maintenance_window.maintenance_window.id
  name          = var.maintenance_window_target_name
  description   = "Maintenance targets for Windows, Linux, or MacOS EC2 instances"
  resource_type = "INSTANCE"
  targets {
    key    = "InstanceIds"
    values = var.patching_ec2_instance_ids
  }
}
