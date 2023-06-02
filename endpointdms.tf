#---------------------------------------------------------------------------------------#
#                 Terraform resource to Create DMS source endpoints                     #
#---------------------------------------------------------------------------------------#
data "aws_secretsmanager_secret" "secrets" {
  arn ="arn:aws:secretsmanager:eu-central-1:299091871285:secret:rds!db-709a51af-f26e-4499-8d45-0cdbf8cca0ed-tNeeqp"
}
data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.secrets.id
}
resource "aws_dms_endpoint" "ec2_mysql_source_endpoint" {
  database_name = "customer_db"
  endpoint_id   = "mysql-source-endpoint"
  endpoint_type = "source"
  engine_name   = "mysql"
  username      = "phpmyadmin"
  password      = local.mysql_root_password
  port          = 3306
  server_name   = aws_instance.db_instance.private_ip
  



  tags = {
    Name = "mysql-source-endpoint"
  }
}
#---------------------------------------------------------------------------------------#
#                    Terraform resource to Create DMS destination endpoints             #
#---------------------------------------------------------------------------------------#
resource "aws_dms_endpoint" "rds_postgres_target_endpoint" {
  database_name = var.db-name
  endpoint_id   = "postgres-target-endpoint"
  endpoint_type = "target"
  engine_name   = "postgres"
  #username      = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["username"]
  username = var.rds_username
  password      = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["password"]
  port          = 5432
  server_name   = aws_db_instance.rds-migration-postgres.address
  kms_key_arn = var.dms-key-arn 
  tags = {
    Name = "postgres-target-endpoint"
  }


}
#---------------------------------------------------------------------------------------#
#                    Terraform resource to Create DMS replication task                  #
#---------------------------------------------------------------------------------------#
resource "aws_dms_replication_task" "migration_task" {
  start_replication_task = true
  migration_type            = "full-load"
  replication_instance_arn  = aws_dms_replication_instance.dms-repli-instance.replication_instance_arn
  replication_task_id       = "test-dms-replication-task-tf"
  replication_task_settings = file("${path.module}/mglab.json")
  source_endpoint_arn       = aws_dms_endpoint.ec2_mysql_source_endpoint.endpoint_arn
  table_mappings            = "{\"rules\":[{\"rule-type\":\"selection\",\"rule-id\":\"1\",\"rule-name\":\"1\",\"object-locator\":{\"schema-name\":\"customer_db\",\"table-name\":\"%\"},\"rule-action\":\"include\"}]}"
  tags = {
    Name = "migration_task"
  }
  target_endpoint_arn = aws_dms_endpoint.rds_postgres_target_endpoint.endpoint_arn
}







