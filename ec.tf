resource "aws_vpc" "samplevpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
}