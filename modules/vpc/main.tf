resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = "${var.name}"
  }
}

resource "aws_subnet" "public_subnet_A01" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "${var.region}a"
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 0)
  map_public_ip_on_launch = true

  tags = {
    "Name" = "${var.name}-subnet-a"
  }
}

resource "aws_subnet" "public_subnet_C01" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "${var.region}c"
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 1)
  map_public_ip_on_launch = true

  tags = {
    "Name" = "${var.name}-subnet-c"
  }
}

resource "aws_subnet" "private_subnet_A05" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "${var.region}a"
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 50)
  map_public_ip_on_launch = false

  tags = {
    "Name" = "${var.name}-db-subnet-1a"
  }
}

resource "aws_subnet" "private_subnet_C05" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "${var.region}c"
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 51)
  map_public_ip_on_launch = false

  tags = {
    "Name" = "${var.name}-db-subnet-1c"
  }
}


resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "${var.name}-api-rtbl"
  }
}


resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  gateway_id             = aws_internet_gateway.internet_gateway.id
  destination_cidr_block = "0.0.0.0/0"
  depends_on = [
    aws_route_table.public_route_table, aws_internet_gateway.internet_gateway
  ]
}


resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
}


resource "aws_route_table_association" "public_A01" {
  subnet_id      = aws_subnet.public_subnet_A01.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_C01" {
  subnet_id      = aws_subnet.public_subnet_C01.id
  route_table_id = aws_route_table.public_route_table.id
}
