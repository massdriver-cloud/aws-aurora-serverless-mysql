locals {
  vpc_id         = element(split("/", var.vpc.data.infrastructure.arn), 1)
  mysql_protocol = "tcp"
  subnet_ids = {
    "internal" = [for subnet in var.vpc.data.infrastructure.internal_subnets : element(split("/", subnet["arn"]), 1)]
    "private" = [for subnet in var.vpc.data.infrastructure.private_subnets : element(split("/", subnet["arn"]), 1)]
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
  engine_mode                     = "serverless"
  engine                          = "aurora-mysql"
  db_cluster_parameter_group_name = "default.aurora-mysql5.7"
  storage_encrypted               = true
  copy_tags_to_snapshot           = true
  skip_final_snapshot             = var.skip_final_snapshot
  final_snapshot_identifier       = var.skip_final_snapshot ? null : "${var.md_metadata.name_prefix}-${element(concat(random_id.snapshot_identifier.*.hex, [""]), 0)}"
  cluster_identifier              = var.md_metadata.name_prefix
  allow_major_version_upgrade     = var.allow_major_version_upgrade
  master_username                 = var.username
  master_password                 = random_password.master_password.result
  deletion_protection             = var.deletion_protection
  backup_retention_period         = var.backup_retention_period
  # backtrack_window = TODO
  port                 = 3306
  enable_http_endpoint = var.enable_http_endpoint
  db_subnet_group_name = aws_db_subnet_group.main.name

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

  # TODO: not sure this applies to serverless
  # apply_immediately               = var.apply_immediately

  # TODO: for restoring from a snapshot
  # snapshot_identifier                 = var.snapshot_identifier

  # TODO: md connection input
  # iam_roles                           = var.iam_roles

  # TODO: md connection input
  # kms_key_id                          = var.kms_key_id
}

# ################################################################################
# # Security Group
# ################################################################################


resource "aws_db_subnet_group" "main" {
  name        = var.md_metadata.name_prefix
  description = "For Aurora cluster ${var.md_metadata.name_prefix}"
  subnet_ids  = local.subnet_ids[var.subnet_type]
}

resource "aws_security_group" "main" {
  vpc_id      = local.vpc_id
  name_prefix = "${var.md_metadata.name_prefix}-"
  description = "Control traffic to/from RDS Aurora ${var.md_metadata.name_prefix}"
}

resource "aws_security_group_rule" "vpc_ingress" {
  count = 1

  description = "From allowed CIDRs"

  type        = "ingress"
  from_port   = aws_rds_cluster.main.port
  to_port     = aws_rds_cluster.main.port
  protocol    = local.mysql_protocol
  cidr_blocks = [var.vpc.data.infrastructure.cidr]

  security_group_id = aws_security_group.main.id
}
