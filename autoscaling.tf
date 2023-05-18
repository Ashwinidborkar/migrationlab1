resource "aws_autoscaling_group" "mglab_autogrp" {
  name                      = "mglb_instance_autoscaling"
  max_size                  = 2
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  #placement_group           = aws_placement_group.test.id
  launch_configuration      = aws_launch_configuration.asg_launch_conf.name
  vpc_zone_identifier       = [data.aws_subnet.public_1.id,data.aws_subnet.public_2.id]
  #availability_zones = local.availability_zones


    tag {
    key                 = "name"
    value               = "pgadmin_server"
    propagate_at_launch = false
  }
} 


resource "aws_launch_configuration" "asg_launch_conf" {
  name          = "mglab_config"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  associate_public_ip_address = true
  key_name = "migration_key"
  security_groups= [aws_security_group.pgadmin_sg.id]
}