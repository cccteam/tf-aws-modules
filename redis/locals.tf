locals {
  subnet_group_name    = var.create_subnet_group != null ? aws_elasticache_subnet_group.this[0].name : var.subnet_group_name
  parameter_group_name = var.create_parameter_group != null ? aws_elasticache_parameter_group.this[0].name : var.parameter_group_name
}
