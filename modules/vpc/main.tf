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
