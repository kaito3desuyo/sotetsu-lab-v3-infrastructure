# data "aws_ami" "for_nat" {
#   most_recent = "true"
#   owners = [
#     "amazon"
#   ]
#   filter {
#     name = "name"
#     values = [
#       "amzn2-ami-hvm-*-x86_64-gp2"
#     ]
#   }
# }

# resource "aws_instance" "for_nat" {
#   ami                     = data.aws_ami.for_nat.id
#   instance_type           = "t3.nano"
#   private_ip              = "10.0.0.254"
#   subnet_id               = aws_subnet.subnet["public_01a"].id
#   vpc_security_group_ids  = [aws_security_group.for_nat_instance.id]
#   key_name                = var.keypair_id
#   iam_instance_profile    = aws_iam_instance_profile.nat_instance_profile.name
#   source_dest_check       = false
#   disable_api_termination = true
#   monitoring              = true
#   user_data = base64encode(
#     file("${path.module}/assets/sh/nat-instance-user-data.sh")
#   )

#   metadata_options {
#     http_endpoint = "enabled"
#     http_tokens   = "required"
#   }

#   root_block_device {
#     encrypted = true
#   }

#   lifecycle {
#     ignore_changes = [
#       ami
#     ]
#   }

#   tags = {
#     "Name" = "${var.name}-nat-instance"
#   }
# }

# resource "aws_eip" "for_nat" {
#   vpc                       = true
#   instance                  = aws_instance.for_nat.id
#   associate_with_private_ip = "10.0.0.254"

#   tags = {
#     "Name" = "${var.name}-nat-instance-eip"
#   }

#   depends_on = [
#     aws_internet_gateway.internet_gateway
#   ]
# }
