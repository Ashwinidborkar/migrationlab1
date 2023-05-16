data "aws_availability_zones" "available" {}





module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

#   name = "my-vpc"
#   cidr = "10.0.0.0/16"
  name = local.name
  cidr = local.vpc_cidr

  azs                 = local.azs
  private_subnets     = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  public_subnets      = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 4)]
  database_subnets    = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 8)]
  private_subnet_names = ["Private Subnet One", "Private Subnet Two"]
  database_subnet_names    = ["DB Subnet One", "DB subnet two"]
  public_subnet_names = ["Public Subnet One", "Public Subnet Two"]

  enable_nat_gateway  = true
  single_nat_gateway  = true
  #reuse_nat_ips       = true  
  enable_vpn_gateway = true                  
     
}