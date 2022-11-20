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

# TODO: Remove this once we have application w/ AWS Sec Groups
resource "aws_security_group_rule" "vpc_ingress" {
  count             = 1
  description       = "From allowed CIDRs"
  type              = "ingress"
  from_port         = aws_rds_cluster.main.port
  to_port           = aws_rds_cluster.main.port
  protocol          = local.mysql_protocol
  cidr_blocks       = [var.vpc.data.infrastructure.cidr]
  security_group_id = aws_security_group.main.id
}
