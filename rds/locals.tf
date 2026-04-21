locals {
  db_subnet_group_name = var.create_subnet_group ? aws_db_subnet_group.this[0].name : var.db_subnet_group_name
}
