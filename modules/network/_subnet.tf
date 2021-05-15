resource "aws_subnet" "subnet" {
  for_each                = local.subnet
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = lookup(each.value, "availability_zone")
  cidr_block              = lookup(each.value, "cidr_block")
  map_public_ip_on_launch = lookup(each.value, "map_public_ip_on_launch", false)

  tags = {
    "Name" = lookup(each.value, "subnet_name")
  }
}
