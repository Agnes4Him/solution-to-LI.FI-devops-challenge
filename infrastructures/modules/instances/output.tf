output "lb_dns" {
    value = aws_lb.task_LB.dns_name
}

output "lb_arn" {
    value = aws_lb.task_LB.arn
}