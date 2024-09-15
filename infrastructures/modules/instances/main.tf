resource "aws_instance" "demo_instance" {
  ami           = var.ami_id
  for_each      = var.instance_subnets
  subnet_id     = each.value
  instance_type = var.instance_type
  vpc_security_group_ids = [
    var.instance_sg
  ]
  key_name                    = var.key_pair_name
  associate_public_ip_address = true

  tags = {
    Name = "instance-${each.key}"
  }
}