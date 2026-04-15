resource "aws_organizations_policy" "this" {
  name         = var.name
  type         = var.type
  content      = var.content
  description  = var.description
  skip_destroy = var.skip_destroy
  tags         = { Name = var.name }
}

resource "aws_organizations_policy_attachment" "this" {
  for_each  = toset(var.target_ids)
  policy_id = aws_organizations_policy.this.id
  target_id = each.value
}
