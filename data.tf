data "aws_availability_zones" "available" {
    state = "available"
}

data "aws_route53_zone" "ashwini-mg" {
  name         = "ash-mglab.aws.crlabs.cloud"
  private_zone = false
}


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_subnet" "public_1" {
  filter {
    name   = "tag:Name"
    values = ["Public Subnet One"]
  }
}

data "aws_subnet" "public_2" {
  filter {
    name   = "tag:Name"
    values = ["Public Subnet Two"]
  }
}

