## AWS Aurora Serverless MySQL

Amazon Aurora Serverless is an on-demand, auto-scaling configuration for Amazon Aurora, where the database automatically starts up, shuts down, and scales capacity up or down based on your application's needs. It provides the full capabilities of Amazon Aurora with a MySQL-compatible database engine and delivers seamless scaling without manual intervention.

### Design Decisions

1. **Engine and Version**:
    - Uses `aurora-mysql` with a default version `5.7`.
2. **Serverless Configuration**:
    - Engine mode set to `serverless`, allowing automatic start-up, shut-down, and scaling.
3. **Backup and Retention**:
    - Backup retention period customizable via variable.
    - Copy tags to snapshots enabled.
4. **Parameter and Security Configurations**:
    - Utilizes default Aurora MySQL parameter group.
    - Storage encrypted and deletion protection enabled.
5. **Scaling Configuration**:
    - Fully configurable auto-scaling settings including `auto_pause`, `max_capacity`, and `min_capacity`.
6. **Networking**:
    - Utilizes subnets provided by the VPC configuration.
    - Security group and rules set to allow traffic on MySQL port.
7. **Monitoring and Alarming**:
    - Automated and custom alarms enabled for database monitoring.
    - Employs CloudWatch Alarms for serverless database capacity monitoring.
8. **Resource Naming and Identification**:
    - Use of identifiers and metadata for naming and tagging resources appropriately.

### Runbook

#### Unable to Connect to Aurora Serverless MySQL

To troubleshoot connectivity issues to the Aurora Serverless MySQL cluster:

1. **Check the RDS Cluster status**:
    
    This command ensures the cluster is available and ready to accept connections.
    
    ```sh
    aws rds describe-db-clusters --db-cluster-identifier <your-cluster-identifier>
    ```

    The status should be `available`.

2. **Verify VPC and Security Group settings**:

    Ensure the RDS cluster security group allows inbound traffic on port `3306` from your IP or CIDR range.

    ```sh
    aws ec2 describe-security-groups --group-ids <your-security-group-id>
    ```

    Look for rules allowing ingress on MySQL's standard port.

3. **Check Database Credentials**:

    Ensure you are using the correct master username and password.
    
    You can reset the master password via:

    ```sh
    aws rds modify-db-cluster --db-cluster-identifier <your-cluster-identifier> --master-user-password <new-password> --apply-immediately
    ```

4. **Verify Subnet and VPC Configuration**:

    Ensure the RDS cluster is associated with the appropriate subnets within your VPC.

    ```sh
    aws rds describe-db-subnet-groups --db-subnet-group-name <your-subnet-group-name>
    ```

#### Slow Query Performance

To troubleshoot slow queries on your Aurora Serverless MySQL:

1. **Review Aurora Performance Insights**:

    Performance Insights can provide detailed information about query performance.

    ```sh
    aws rds describe-resource-metrics --service-type RDS --identifier <your-cluster-identifier> --metric-queries '{"Metric": "db.Load.avg", "Dimensions": [{"Name": "DBClusterIdentifier", "Value": "<your-cluster-identifier>"}]}' --start-time $(date --utc --date='-5 minutes' +%Y-%m-%dT%H:%M:%SZ) --end-time $(date --utc +%Y-%m-%dT%H:%M:%SZ)
    ```

2. **Enable and Check Slow Query Log**:

    Ensure that the slow query log is enabled and review entries.

    ```sql
    -- Enable slow query log
    SET GLOBAL slow_query_log = 'ON';

    -- View slow queries
    SELECT * FROM mysql.slow_log ORDER BY start_time DESC;
    ```

3. **Analyze Query Execution Plans**:

    Use `EXPLAIN` to analyze how MySQL executes your queries.

    ```sql
    EXPLAIN SELECT * FROM your_table WHERE your_column = 'value';
    ```

    This provides insights into index usage and query complexity.

4. **Optimize Database Schema and Indexes**:

    Ensure your database schema is optimized, and proper indexes are in place.

    ```sql
    -- View current indexes
    SHOW INDEX FROM your_table;

    -- Adding an index example
    CREATE INDEX idx_your_column ON your_table (your_column);
    ```

These runbooks provide essential commands and SQL statements to help diagnose and troubleshoot common issues with AWS Aurora Serverless MySQL.

