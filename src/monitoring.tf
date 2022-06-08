
locals {
  database_capacity_percent   = 0.9
  database_capacity_threshold = local.database_capacity_percent * var.scaling_configuration["max_capacity"]
}

module "database_capacity_alarm" {
  source = "../../../provisioners/terraform/modules/aws-cloudwatch-alarm"

  depends_on = [
    aws_rds_cluster.main
  ]

  md_metadata         = var.md_metadata
  message             = "RDS Aurora ${aws_rds_cluster.main.cluster_identifier}: Serverless Database Capacity > ${local.database_capacity_percent * 100}% of Max"
  alarm_sns_topic_arn = var.vpc.data.observability.alarm_sns_topic_arn

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
