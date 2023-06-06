resource "aws_security_group" "app_sg" {
  # checkov:skip=CKV2_AWS_5: ADD REASON
  # checkov:skip=CKV_AWS_260: ADD REASON
  # checkov:skip=CKV_AWS_23: ADD REASON
  # checkov:skip=CKV_AWS_24: ADD REASON
  name        = "app-server-sg"
  description = "Allow connection for pgadmin server security group."
  vpc_id      = module.vpc_onprem.vpc_id

  ingress {
    description = "Allow port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow port 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
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
    Name = "app-server-sg"
  }
}

resource "aws_security_group" "db_sg" {
  # checkov:skip=CKV2_AWS_5: ADD REASON
  # checkov:skip=CKV_AWS_23: ADD REASON
  name        = "db-server-sg"
  description = "Allow connection for pgadmin server security group."
  vpc_id      = module.vpc_onprem.vpc_id

  ingress {
    description     = "Allow port 22"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id, aws_security_group.repli_sg.id]
    #cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    description     = "Allow port 3306"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id, aws_security_group.repli_sg.id]
    cidr_blocks     = ["10.0.8.202/32", local.vpc_cidr, local.vpc_cidr_onprem]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "db-server-sg"
  }
}