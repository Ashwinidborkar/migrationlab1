 resource "aws_acm_certificate" "cert" {
  domain_name       = "ashwini-mglab.aws.crlabs.cloud"
  validation_method = "DNS"
 }

 resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  #validation_record_fqdns = [for record in aws_route53_record.cert:record.fqdn]
 }