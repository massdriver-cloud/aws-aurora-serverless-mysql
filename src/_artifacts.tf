locals {
  data_authentication = {
    username = aws_rds_cluster.main.master_username
    password = aws_rds_cluster.main.master_password
    hostname = aws_rds_cluster.main.endpoint
    # replica_hostname = aws_rds_cluster.main.reader_endpoint
    port = aws_rds_cluster.main.port
  }
  data_infrastructure = {
    arn = aws_rds_cluster.main.arn
  }

  rdbms_specs = {
    engine         = "MySQL"
    engine_version = aws_rds_cluster.main.engine_version
    version        = aws_rds_cluster.main.engine_version_actual
  }
}

resource "massdriver_artifact" "authentication" {
  field                = "authentication"
  provider_resource_id = aws_rds_cluster.main.arn
  specification_path   = "../massdriver.yaml"
  name                 = "MySQL user credentials: ${aws_rds_cluster.main.cluster_identifier}"
  artifact = jsonencode(
    {
      data = {
        infrastructure = local.data_infrastructure
        authentication = local.data_authentication
        security       = {}
      }
      specs = {
        rdbms = local.rdbms_specs
      }
    }
  )
}
