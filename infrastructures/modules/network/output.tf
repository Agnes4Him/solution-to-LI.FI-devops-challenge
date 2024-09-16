output "vpc_id" {
  value = aws_vpc.task_vpc.id
}

output "private_subnetA" {
  value = aws_subnet.private_subnetA.id
}

output "private_subnetB" {
  value = aws_subnet.private_subnetB.id
}

output "public_subnetA" {
  value = aws_subnet.public_subnetA.id
}

output "public_subnetB" {
  value = aws_subnet.public_subnetB.id
}

output "instance_sg" {
  value = aws_security_group.instance_sg.id
}

output "lb_sg" {
  value = aws_security_group.lb_sg.id
}