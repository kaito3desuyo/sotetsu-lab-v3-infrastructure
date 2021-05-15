variable "region" {}
variable "name" {}

variable "cidr_block" {}
variable "bastion_cidr_block" {}

locals {
  subnet = {
    public_01a = {
      subnet_name             = "${var.name}-public-subnet-01a"
      availability_zone       = "${var.region}a"
      cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 0)
      map_public_ip_on_launch = true
      route_table_id          = aws_route_table.public_route_table.id
    }
    public_01c = {
      subnet_name             = "${var.name}-public-subnet-01c"
      availability_zone       = "${var.region}c"
      cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 1)
      map_public_ip_on_launch = true
      route_table_id          = aws_route_table.public_route_table.id
    }
    public_01d = {
      subnet_name             = "${var.name}-public-subnet-01d"
      availability_zone       = "${var.region}d"
      cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 2)
      map_public_ip_on_launch = true
      route_table_id          = aws_route_table.public_route_table.id
    }

    db_01a = {
      subnet_name       = "${var.name}-db-subnet-01a"
      availability_zone = "${var.region}a"
      cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 50)
      route_table_id    = aws_route_table.db_route_table.id
    }
    db_01c = {
      subnet_name       = "${var.name}-db-subnet-01c"
      availability_zone = "${var.region}c"
      cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 51)
      route_table_id    = aws_route_table.db_route_table.id
    }
    db_01d = {
      subnet_name       = "${var.name}-db-subnet-01d"
      availability_zone = "${var.region}d"
      cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 52)
      route_table_id    = aws_route_table.db_route_table.id
    }
  }
}
