#RDS instance
resource "aws_db_instance" "rds-migration-postgres" {
  # checkov:skip=CKV_AWS_161: ADD REASON
  # checkov:skip=CKV_AWS_118: ADD REASON
  # checkov:skip=CKV_AWS_129: ADD REASON
  instance_class          = "db.t3.medium"
  db_name                 = var.db-name
  identifier              = var.rds_name
  allocated_storage       = 20
  storage_type            = "gp3"
  engine                  = "postgres"
  engine_version          = "14"
  port                    = "5432"
  backup_retention_period = 7
  backup_window           = "14:30-15:50"
  db_subnet_group_name    = module.vpc.database_subnet_group
  username                = var.rds_username
  publicly_accessible     = true
  #deletion_protection         = false
  skip_final_snapshot        = true
  storage_encrypted          = true
  availability_zone          = local.azs[0]
  apply_immediately          = true
  vpc_security_group_ids     = [aws_security_group.rds_sg.id]
  snapshot_identifier        = null
  maintenance_window         = "Sun:10:30-Sun:12:30"
  auto_minor_version_upgrade = true
  #password = var.password-for-rds
  manage_master_user_password = true
  kms_key_id                  = var.kms-key-rds-arn


  #iam_database_authentication_enabled = true

  dynamic "restore_to_point_in_time" {
    for_each = var.restore_to_point_in_time
    content {
      restore_time                  = restore_to_point_in_time.value["restore_time"]
      source_db_instance_identifier = restore_to_point_in_time.value["source_db_instance_identifier"]
      source_dbi_resource_id        = restore_to_point_in_time.value["source_dbi_resource_id"]
      use_latest_restorable_time    = restore_to_point_in_time.value["use_latest_restorable_time"]
    }
  }


  tags = {
    name = "rds-mg"
  }
}


resource "aws_security_group" "rds_sg" {
  # checkov:skip=CKV_AWS_23: ADD REASON
  name        = "rds_sg"
  description = "Rds postgress sec group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "open port 5432"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    #security_groups = [aws_security_group.pgadmin_sg.id]
    cidr_blocks = [local.vpc_cidr, local.vpc_cidr_onprem]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "rds-server-sg"
  }
}










  