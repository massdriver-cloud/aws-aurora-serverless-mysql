
locals {

  _automatic_database_capacity_threshold = 0.9
  automated_alarms = {
    database_capacity = {
      period    = 300
      threshold = floor(local._automatic_database_capacity_threshold * var.scaling_configuration["max_capacity"])
    }
  }
  alarms_map = {
    "AUTOMATED" = local.automated_alarms
    "DISABLED"  = {}
    "CUSTOM"    = lookup(var.monitoring, "alarms", {})
  }

  alarms = lookup(local.alarms_map, var.monitoring.mode, {})
}

module "alarm_channel" {
  source      = "github.com/massdriver-cloud/terraform-modules//aws-alarm-channel?ref=aa08797"
  md_metadata = var.md_metadata
}

module "database_capacity_alarm" {
  count = lookup(local.alarms, "database_capacity", null) == null ? 0 : 1

  source        = "github.com/massdriver-cloud/terraform-modules//aws-cloudwatch-alarm?ref=8997456"
  sns_topic_arn = module.alarm_channel.arn
  depends_on = [
    aws_rds_cluster.main
  ]

  md_metadata         = var.md_metadata
  display_name        = "Database Capacity"
  message             = "RDS Aurora ${aws_rds_cluster.main.cluster_identifier}: Serverless Database Capacity has exceed capacity of ${local.alarms.database_capacity.threshold}"
  alarm_name          = "${aws_rds_cluster.main.cluster_identifier}-highServerlessDatabaseCapacity"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ServerlessDatabaseCapacity"
  namespace           = "AWS/RDS"
  statistic           = "Average"
  period              = local.alarms.database_capacity.period
  threshold           = local.alarms.database_capacity.threshold

  dimensions = {
    DBClusterIdentifier = aws_rds_cluster.main.cluster_identifier
  }
}
