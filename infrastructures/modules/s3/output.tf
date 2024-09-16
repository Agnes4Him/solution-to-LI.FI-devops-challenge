output "logs_bucket" {
    value = aws_s3_bucket.task_logs_bucket.bucket
}