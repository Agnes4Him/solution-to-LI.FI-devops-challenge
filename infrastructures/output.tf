output "instance_ip" {
  value = values(module.instances)[*].public_ip
}

output "instance_dns" {
  value = values(module.instances)[*].public_dns
}