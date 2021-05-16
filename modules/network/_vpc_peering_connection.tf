resource "aws_vpc_peering_connection" "from_seapolis_development" {
  vpc_id      = "vpc-0175aee1bd10ce9fc"
  peer_vpc_id = aws_vpc.vpc.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  tags = {
    "Name" = "${var.name}-pcx"
  }
}
