output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  value = [aws_subnet.public_subnet_A01.id, aws_subnet.public_subnet_C01.id]
}

output "db_subnet_ids" {
  value = [aws_subnet.private_subnet_A05.id, aws_subnet.private_subnet_C05.id]
}
