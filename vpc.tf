
locals {
  name        = "migration_vpc"
  name_onprem = "onprem_vpc"
  #region   = "eu-central-1"
  vpc_cidr            = "10.0.0.0/16"
  vpc_cidr_onprem     = "192.168.0.0/16"
  azs                 = slice(data.aws_availability_zones.available.names, 0, 2)
  azs_onprem          = slice(data.aws_availability_zones.available.names, 0, 2)
  mysql_root_password = "Mahee@0180"
  rep_private_ip ="10.0.8.202"
  # checkov:skip=CKV_SECRET_80: ADD REASON

  #data "aws_availability_zones" "available" {}
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.1"

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



}




module "vpc_onprem" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.1"


  name = local.name_onprem
  cidr = local.vpc_cidr_onprem

  azs              = local.azs_onprem
  private_subnets  = [for k, v in local.azs_onprem : cidrsubnet(local.vpc_cidr_onprem, 8, k)]
  database_subnets = [for k, v in local.azs_onprem : cidrsubnet(local.vpc_cidr_onprem, 8, k + 8)]
  public_subnets   = [for k, v in local.azs_onprem : cidrsubnet(local.vpc_cidr_onprem, 8, k + 4)]

  private_subnet_names    = ["Private Subnet Onprem One", "Private Subnet OnpremTwo"]
  database_subnet_names   = ["DB Subnet Onprem One", "DB subnet Onprem two"]
  public_subnet_names     = ["Public Subnet Onprem One", "Public Subnet Onprem Two"]
  map_public_ip_on_launch = true

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false
}
