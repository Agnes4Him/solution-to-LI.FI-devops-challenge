output "vpc_id" {
  value = aws_vpc.demo_vpc.id
}

output "db_subnetA" {
  value = aws_subnet.private_subnetA.id
}

output "db_subnetB" {
  value = aws_subnet.private_subnetB.id
}

output "db_sg" {
  value = aws_security_group.db_sg.id
}

output "instance_sg" {
  value = aws_security_group.instance_sg.id
}