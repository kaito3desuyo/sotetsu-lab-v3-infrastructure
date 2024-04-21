# resource "aws_security_group" "for_nat_instance" {
#   name        = "${var.name}-nat-instance-sg"
#   description = "for NAT Instance"
#   vpc_id      = aws_vpc.vpc.id

#   ingress {
#     from_port = 0
#     to_port   = 0
#     protocol  = "-1"
#     cidr_blocks = [
#       aws_subnet.subnet["private_01a"].cidr_block,
#       aws_subnet.subnet["private_01c"].cidr_block,
#       aws_subnet.subnet["private_01d"].cidr_block,
#     ]
#     description = "Allow ALL from Private Subnet"
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#     description = "Allow ALL to ANY"
#   }

#   tags = {
#     "Name" = "${var.name}-nat-instance-sg"
#   }
# }
