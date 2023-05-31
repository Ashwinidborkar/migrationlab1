# VPC peering connection

resource "aws_vpc_peering_connection" "mglab_peering" {
  peer_owner_id = var.peer_owner_id
  peer_vpc_id   = module.vpc_onprem.vpc_id
  vpc_id        = module.vpc.vpc_id
  auto_accept   = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }


  tags = {
    Name    = "peering-connection"
    Project = "migration-lab"
    Side    = "Requester"
  }
}

# Accepter side connection
resource "aws_vpc_peering_connection_accepter" "peer" {
  vpc_peering_connection_id = aws_vpc_peering_connection.mglab_peering.id
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }

}

#Route tables for cloud vpc peering
data "aws_route_tables" "cloud_vpc_route" {
  vpc_id = module.vpc.vpc_id
}

# creating a route
resource "aws_route" "cloud_route" {
  count                     = length(data.aws_route_tables.cloud_vpc_route.ids)
  route_table_id            = (data.aws_route_tables.cloud_vpc_route.ids)[count.index]
  destination_cidr_block    = local.vpc_cidr_onprem
  vpc_peering_connection_id = aws_vpc_peering_connection.mglab_peering.id
}

#Route tables for Onprem vpc peering
data "aws_route_tables" "Onprem_vpc_route" {
  vpc_id = module.vpc_onprem.vpc_id
}

# creating a route
resource "aws_route" "Onprem_route" {
  count                     = length(data.aws_route_tables.Onprem_vpc_route.ids)
  route_table_id            = (data.aws_route_tables.Onprem_vpc_route.ids)[count.index]
  destination_cidr_block    = local.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.mglab_peering.id
}

