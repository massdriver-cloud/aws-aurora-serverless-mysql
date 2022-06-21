
locals {
  database_capacity_percent   = 0.9
  database_capacity_threshold = local.database_capacity_percent * var.scaling_configuration["max_capacity"]
}
module "alarm_channel" {
  source      = "github.com/massdriver-cloud/terraform-modules//aws-alarm-channel?ref=aa08797"
  md_metadata = var.md_metadata
}

module "database_capacity_alarm" {
  source        = "github.com/massdriver-cloud/terraform-modules//aws-cloudwatch-alarm?ref=8997456"
  sns_topic_arn = module.alarm_channel.arn
  depends_on = [
    aws_rds_cluster.main
  ]

  md_metadata         = var.md_metadata
  display_name        = "Database Capacity"
  message             = "RDS Aurora ${aws_rds_cluster.main.cluster_identifier}: Serverless Database Capacity > ${local.database_capacity_percent * 100}% of Max"
  alarm_name          = "${aws_rds_cluster.main.cluster_identifier}-highServerlessDatabaseCapacity"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ServerlessDatabaseCapacity"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = local.database_capacity_threshold

  dimensions = {
    DBClusterIdentifier = aws_rds_cluster.main.cluster_identifier
  }
}
