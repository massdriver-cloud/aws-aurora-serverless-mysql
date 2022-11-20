locals {
  vpc_id         = element(split("/", var.vpc.data.infrastructure.arn), 1)
  mysql_version  = "5.7"
  mysql_protocol = "tcp"
  subnet_ids = {
    "internal" = [for subnet in var.vpc.data.infrastructure.internal_subnets : element(split("/", subnet["arn"]), 1)]
    "private"  = [for subnet in var.vpc.data.infrastructure.private_subnets : element(split("/", subnet["arn"]), 1)]
  }
}
resource "random_password" "master_password" {
  length  = 10
  special = false
}

resource "random_id" "snapshot_identifier" {
  byte_length = 4
}

resource "aws_rds_cluster" "main" {
  engine_mode    = "serverless"
  engine         = "aurora-mysql"
  engine_version = var.mysql_version

  db_cluster_parameter_group_name = "default.aurora-mysql${var.mysql_version}"
  storage_encrypted               = true
  copy_tags_to_snapshot           = true
  allow_major_version_upgrade     = true
  skip_final_snapshot             = var.skip_final_snapshot
  final_snapshot_identifier       = var.skip_final_snapshot ? null : "${var.md_metadata.name_prefix}-${element(concat(random_id.snapshot_identifier.*.hex, [""]), 0)}"
  cluster_identifier              = var.md_metadata.name_prefix
  master_username                 = var.username
  master_password                 = random_password.master_password.result
  deletion_protection             = var.deletion_protection
  backup_retention_period         = var.backup_retention_period
  port                            = 3306
  enable_http_endpoint            = var.enable_http_endpoint
  db_subnet_group_name            = aws_db_subnet_group.main.name

  # TODO: accept vpc_security_group_ids
  # vpc_security_group_ids              = compact(concat(aws_security_group.main.*.id, var.vpc_security_group_ids))
  vpc_security_group_ids = [aws_security_group.main.id]

  scaling_configuration {
    auto_pause               = var.scaling_configuration["auto_pause"]
    max_capacity             = var.scaling_configuration["max_capacity"]
    min_capacity             = var.scaling_configuration["min_capacity"]
    seconds_until_auto_pause = var.scaling_configuration["seconds_until_auto_pause"]
    timeout_action           = var.scaling_configuration["timeout_action"]
  }

  apply_immediately = var.apply_immediately
}
