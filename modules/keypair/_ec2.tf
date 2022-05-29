resource "aws_key_pair" "keypair" {
  key_name   = "${var.name}-key"
  public_key = file("${path.root}/ssh/${var.name}.pub")
}
