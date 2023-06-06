
data "aws_iam_policy_document" "dms_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["dms.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "dms-access-for-endpoint" {
  assume_role_policy = data.aws_iam_policy_document.dms_assume_role.json
  name               = "dms-access-for-endpoint"
}

resource "aws_iam_role_policy_attachment" "dms-access-for-endpoint-AmazonDMSRedshiftS3Role" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSRedshiftS3Role"
  role       = aws_iam_role.dms-access-for-endpoint.name
}

resource "aws_iam_role" "dms-cloudwatch-logs-role" {
  assume_role_policy = data.aws_iam_policy_document.dms_assume_role.json
  name               = "dms-cloudwatch-logs-role"
}

resource "aws_iam_role_policy_attachment" "dms-cloudwatch-logs-role-AmazonDMSCloudWatchLogsRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSCloudWatchLogsRole"
  role       = aws_iam_role.dms-cloudwatch-logs-role.name
}

resource "aws_iam_role" "dms-vpc-role" {
  assume_role_policy = data.aws_iam_policy_document.dms_assume_role.json
  name               = "dms-vpc-role"
}

resource "aws_iam_role_policy_attachment" "dms-vpc-role-AmazonDMSVPCManagementRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSVPCManagementRole"
  role       = aws_iam_role.dms-vpc-role.name
}




# Create a new DMS replication instance
resource "aws_dms_replication_instance" "dms-repli-instance" {
  allocated_storage            = 20
  apply_immediately            = true
  auto_minor_version_upgrade   = true
  availability_zone            = local.azs[0]
  engine_version               = "3.4.7"
  multi_az                     = false
  preferred_maintenance_window = "Sun:01:30-Sun:02:30"
  publicly_accessible          = false
  replication_instance_class   = "dms.t3.micro"
  replication_instance_id      = "dms-repli-instance"
  replication_subnet_group_id  = aws_dms_replication_subnet_group.dms-sg-group.id
  vpc_security_group_ids       = [aws_security_group.rds_sg.id, aws_security_group.repli_sg.id]
  kms_key_arn                  = var.dms-key-arn

  tags = {
    Name = "Rds-replication-instance"
  }


  depends_on = [
    aws_iam_role_policy_attachment.dms-access-for-endpoint-AmazonDMSRedshiftS3Role,
    aws_iam_role_policy_attachment.dms-cloudwatch-logs-role-AmazonDMSCloudWatchLogsRole,
    aws_iam_role_policy_attachment.dms-vpc-role-AmazonDMSVPCManagementRole
  ]
}

# Create a subnet group using existing VPC subnets
resource "aws_dms_replication_subnet_group" "dms-sg-group" {
  replication_subnet_group_description = "DMS replication subnet group"
  replication_subnet_group_id          = "dms-repli-instance"
  subnet_ids                           = ["subnet-007f8bc5097b4501b", "subnet-03a613f7d994c16cd"]

}

# SG group for repli instance
resource "aws_security_group" "repli_sg" {
  # checkov:skip=CKV_AWS_23: ADD REASON
  name        = "repli_sg"
  description = "Rds postgress sec group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "open port 5432"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    #security_groups = [aws_security_group.pgadmin_sg.id]
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "open port 3306"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    #security_groups = [aws_security_group.pgadmin_sg.id]
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "repli-server-sg"
  }
}