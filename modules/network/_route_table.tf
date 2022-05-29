resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "${var.name}-public-rtbl"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  gateway_id             = aws_internet_gateway.internet_gateway.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "${var.name}-private-rtbl"
  }
}

resource "aws_route_table" "db_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "${var.name}-db-rtbl"
  }
}

resource "aws_route" "db_route" {
  route_table_id            = aws_route_table.db_route_table.id
  vpc_peering_connection_id = aws_vpc_peering_connection.from_seapolis_development.id
  destination_cidr_block    = var.bastion_cidr_block
}

resource "aws_route_table_association" "route_table_association" {
  for_each       = local.subnet
  subnet_id      = aws_subnet.subnet[each.key].id
  route_table_id = lookup(each.value, "route_table_id")
}
