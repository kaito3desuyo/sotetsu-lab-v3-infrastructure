output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  value = [aws_subnet.subnet["public_01a"].id, aws_subnet.subnet["public_01c"].id, aws_subnet.subnet["public_01d"].id]
}

output "db_subnet_ids" {
  value = [aws_subnet.subnet["db_01a"].id, aws_subnet.subnet["db_01c"].id, aws_subnet.subnet["db_01d"].id]
}
