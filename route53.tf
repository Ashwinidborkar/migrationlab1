# resource "aws_elb" "main" {
#   name               = "migration-terraform-elb"
#   availability_zones = ["eu-central-1a","eu-central-1b"]

#   listener {
#     instance_port     = 80
#     instance_protocol = "http"
#     lb_port           = 80
#     lb_protocol       = "http"
#   }
# }

# resource "aws_route53_zone" "public_hosted_zone" {
#   name = "ashwini-mglab.aws.crlabs.cloud"
# }


# resource "aws_route53_record" "cert" {
#   zone_id = aws_route53_zone.public_hosted_zone.id
#   name    = "resolve-test"
#   type    = "A"
#   ttl     = 300
#   records = ["10.0.0.0"]

  
#}



