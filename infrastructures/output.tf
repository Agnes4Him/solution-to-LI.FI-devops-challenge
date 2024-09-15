
output "instance_ip" {
  value = values(module.instance)[*].public_ip
}

output "instance_dns" {
  value = values(module.instance)[*].public_dns
}