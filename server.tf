## Onprem Application server

#app server
resource "aws_instance" "app_instance" {
  # checkov:skip=CKV_AWS_126: ADD REASON
  # checkov:skip=CKV_AWS_8: ADD REASON
  depends_on    = [aws_instance.db_instance]
  ami           = var.ami_for_appserver
  instance_type = "t2.medium"
  key_name      = "migration_key"
  user_data = templatefile("${path.module}/app_user_data.sh.tpl", {
    db_private_ip       = aws_instance.db_instance.private_ip,
    mysql_root_password = local.mysql_root_password
  })
  network_interface {
    network_interface_id = aws_network_interface.app_eni.id
    device_index         = 0
  }
  tags = {
    Name = "app-server"
  }

}

#network interface
resource "aws_network_interface" "app_eni" {
  subnet_id       = data.aws_subnet.on_prem_app_subnet.id
  security_groups = [aws_security_group.app_sg.id]
}


#database server
resource "aws_instance" "db_instance" {
  # checkov:skip=CKV_AWS_79: ADD REASON
  ami                    = var.ami_for_appserver
  instance_type          = "t2.medium"
  subnet_id              = data.aws_subnet.on_prem_db_subnet.id
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  key_name               = "migration_key"
  user_data = templatefile("${path.module}/db_user_data.sh.tpl", {
    app_private_ip      = aws_network_interface.app_eni.private_ip,
    mysql_root_password = local.mysql_root_password
  })
  tags = {
    Name = "db-server"
  }
}
