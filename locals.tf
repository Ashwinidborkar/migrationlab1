# locals {
#   name   = "migration_vpc"
#   region = "eu-central-1"

#   vpc_cidr = "10.0.0.0/16"
#   azs      = slice(data.aws_availability_zones.available.names, 0, 2)

#   tags = {
#     Example    = local.name
#     GithubRepo = "terraform-aws-vpc"
#     GithubOrg  = "terraform-aws-modules"
#   }

#   public_hosted_ip ="192.0.2.235"
# }


locals {
  availability_zones      = slice(data.aws_availability_zones.available.names, 0, var.number_of_azs)

  public_subnet_cidr      = cidrsubnet(var.vpc_cidr, 1, 0)
  private_subnet_cidr     = cidrsubnet(var.vpc_cidr, 1, 1)
  database_subnet_cidr    = cidrsubnet(local.private_subnet_cidr, 2, 1)
  
}