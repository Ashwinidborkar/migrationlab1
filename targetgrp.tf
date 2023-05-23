resource "aws_lb_target_group" "alb-example" {
  name = "tf-example-lb-alb-tg"
  #target_type = "alb"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
  health_check {
    path                = "/"
    port                = 80
    healthy_threshold   = 6
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 5
    #matcher = "200"  # has to be HTTP 200 or fails
  }
}
resource "aws_autoscaling_attachment" "asg_attachment_bar1" {
  # checkov:skip=CKV2_AWS_15: ADD REASON
  autoscaling_group_name = aws_autoscaling_group.mglab_autogrp.id
  lb_target_group_arn    = aws_lb_target_group.alb-example.arn

}


