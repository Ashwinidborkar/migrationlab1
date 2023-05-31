# Create an endpoint for the source database

resource "aws_dms_endpoint" "source" {
  database_name = "my-source-db"
  endpoint_id   = "db-src-endpoint"
  endpoint_type = "source"
  engine_name   = "mysql"
  port          = "3306"
  server_name   = "mysql"
  ssl_mode      = "none"
  username      = "Ashwini"
  password      = var.password-for-dms

  tags = {
    Name = "Source-endopint"
  }
}

# Create an endpoint for the target database

resource "aws_dms_endpoint" "target" {
  database_name = "my-target-db"
  endpoint_id   = "db-tar-endpoint"
  endpoint_type = "target"
  engine_name   = "postgres"
  port          = "8635"
  server_name   = "postgres"
  ssl_mode      = "none"
  username      = "Ashwini"
  password      = var.password-for-dms


  tags = {
    Name = "Target-endpoint"

  }
}

# Replication Task
resource "aws_dms_replication_task" "rt-mssql-pg" {
  migration_type           = "full-load"
  replication_instance_arn = aws_dms_replication_instance.dms-repli-instance.replication_instance_arn
  replication_task_id      = "dms-rt-mssql-pg"
  source_endpoint_arn      = aws_dms_endpoint.source.endpoint_arn
  target_endpoint_arn      = aws_dms_endpoint.target.endpoint_arn
  table_mappings           = "{\"rules\":[{\"rule-type\":\"selection\",\"rule-id\":\"1\",\"rule-name\":\"1\",\"object-locator\":{\"schema-name\":\"%\",\"table-name\":\"%\"},\"rule-action\":\"include\"}]}"


  tags = {
    Name = "test-replication"
  }
}

