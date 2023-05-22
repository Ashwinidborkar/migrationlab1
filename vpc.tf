
locals {
  name     = "migration_vpc"
  region   = "eu-central-1"
  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 2)

  #data "aws_availability_zones" "available" {}
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"



  name = local.name
  cidr = local.vpc_cidr

  azs                   = local.azs
  private_subnets       = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  public_subnets        = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 4)]
  database_subnets      = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 8)]
  private_subnet_names  = ["Private Subnet One", "Private Subnet Two"]
  database_subnet_names = ["DB Subnet One", "DB subnet two"]
  public_subnet_names   = ["Public Subnet One", "Public Subnet Two"]

  enable_nat_gateway = true
  single_nat_gateway = true
  #   #reuse_nat_ips       = true  
  enable_vpn_gateway = true

}

# module "vpc" {
#   source = "terraform-aws-modules/vpc/aws"

#   name = var.vpc_name
#   cidr = var.vpc_cidr

#   azs             = local.availability_zones
#   private_subnets = [for i, v in local.availability_zones : cidrsubnet(local.private_subnet_cidr, 2, i)]
#   public_subnets  = [for i, v in local.availability_zones : cidrsubnet(local.public_subnet_cidr, 2, i)]
#   database_subnets = [for i, v in local.availability_zones : cidrsubnet(local.private_subnet_cidr, 2, i)]
#   database_subnet_group_name = var.database_subnet_group_name

#   enable_nat_gateway = true
#   enable_vpn_gateway = true
#   single_nat_gateway = true
#   one_nat_gateway_per_az = false

#   tags = var.tags
# }

# data "aws_availability_zones" "az" {
#   state = "available"
# }