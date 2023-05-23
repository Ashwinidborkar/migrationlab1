# Load balancer mglab-lb
resource "aws_lb" "mglab-lb" {
  # checkov:skip=CKV2_AWS_28: ADD REASON
  # checkov:skip=CKV_AWS_131: ADD REASON
  # checkov:skip=CKV_AWS_91: ADD REASON
  # checkov:skip=CKV_AWS_150: ADD REASON
  name               = "mglab-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = module.vpc.public_subnets
  security_groups    = [aws_security_group.internet_face.id]
}

# sec group for ALB
resource "aws_security_group" "internet_face" {
  # checkov:skip=CKV_AWS_23: ADD REASON
  # checkov:skip=CKV_AWS_260: ADD REASON
  name        = "allow-tls"
  description = "allow tls inbound traffic"
  vpc_id      = module.vpc.vpc_id
  ingress {
    description = "TLS from vpc"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TLS from vpc"
    from_port   = 80
    to_port     = 80
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
    name = "allow all traffic"
  }
}

# Listener for port 80
resource "aws_lb_listener" "alb_listener_80" {
  load_balancer_arn = aws_lb.mglab-lb.arn
  port              = "80"
  protocol          = "HTTP"

  #   default_action {
  #     type             = "forward"
  #     target_group_arn = aws_lb_target_group.target_group_alb.arn
  #   }
  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}



resource "aws_lb_listener" "front_end" {
  #depends_on = [ aws_acm_certificate.cert ]
  load_balancer_arn = aws_lb.mglab-lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  #certificate_arn = “arn:aws:acm:eu-west-1:217741831553:certificate/f3ee1939-5812-497a-8ed1-18cc17caf098”
  certificate_arn = aws_acm_certificate.mglab-cert.arn
  #   default_action {
  #     type = "fixed-response"
  #     fixed_response {
  #       content_type = "text/plain"
  #       message_body = "fixed response content"
  #       status_code = "200"
  #     }
  # } 
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-example.arn
  }
}
resource "aws_route53_record" "aliaslb" {
  zone_id = data.aws_route53_zone.ashwini-mg.zone_id
  name    = ""
  type    = "A"
  alias {
    name                   = aws_lb.mglab-lb.dns_name
    zone_id                = aws_lb.mglab-lb.zone_id
    evaluate_target_health = true
  }

}


