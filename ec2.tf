
resource "aws_instance" "pgadmin_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.pgadmin_sg.id]

  key_name = "migration_key"
  subnet_id = data.aws_subnet.public_1.id


  tags = {
    Name = "pgmin server1"
  }
}

resource "aws_instance" "pgadmin_instance2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.pgadmin_sg.id]

  key_name = "migration_key"
  subnet_id = data.aws_subnet.public_2.id


  tags = {
    Name = "pgmin server2"
  }
}


resource "aws_security_group" "pgadmin_sg" {

  name        = "pgadmin_sg"
  description = "Allow connect for pgadmin inbound traffic"
  vpc_id      = module.vpc.vpc_id


  ingress {
    description      = "Allow port 80"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = [aws_security_group.internet_face.id]
  }


  ingress {
    description      = "Allow port 22"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
   }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "pgadmin_server"
  }
}
