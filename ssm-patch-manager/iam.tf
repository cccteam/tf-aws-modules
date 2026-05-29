data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_iam_policy_document" "assume_role" {
  statement {
    sid     = "AssumeRole"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
        "ssm.amazonaws.com",
        "ec2.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "this" {
  count              = var.create_iam_role ? 1 : 0
  name               = var.ssm_iam_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  tags = {
    Name = var.ssm_iam_role_name
  }
}

data "aws_iam_policy_document" "permissions" {
  statement {
    sid = "Cloudwatch"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]
    resources = ["arn:aws:logs:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:log-group:${var.cloudwatch_log_group_name}:*"]
  }
}

resource "aws_iam_policy" "permissions" {
  count       = var.create_iam_role ? 1 : 0
  name        = var.ssm_iam_policy_name
  description = "Additional permissions for SSM maintenance window service role."
  policy      = data.aws_iam_policy_document.permissions.json
}

resource "aws_iam_role_policy_attachment" "ec2_maint_role" {
  count      = var.create_iam_role ? 1 : 0
  role       = aws_iam_role.this[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonSSMMaintenanceWindowRole"
}

resource "aws_iam_role_policy_attachment" "ssm_managed_core" {
  count      = var.create_iam_role ? 1 : 0
  role       = aws_iam_role.this[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "permissions" {
  count      = var.create_iam_role ? 1 : 0
  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.permissions[0].arn
}
