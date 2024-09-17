resource "aws_s3_bucket" "task_logs_bucket" {                       # S3 bucket for storing access logs sent from Application Load Balancer
  bucket        = var.logs_bucket
  force_destroy = true

  tags = {
    Name = "${var.env}-bucket"
  }

}

data "aws_elb_service_account" "main" {}

data "aws_iam_policy_document" "s3_bucket_lb_write" {               # Fetch policy document needed to create policy for S3 bucket access
  policy_id = "s3_bucket_lb_logs"

  statement {
    actions = [
      "s3:PutObject",
    ]
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.task_logs_bucket.arn}/*",
    ]

    principals {
      identifiers = ["${data.aws_elb_service_account.main.arn}"]
      type        = "AWS"
    }
  }
}

resource "aws_s3_bucket_policy" "task_logs_policy" {                       # Attach the above policy to the access logs S3 bucket
  bucket = aws_s3_bucket.task_logs_bucket.id
  policy = data.aws_iam_policy_document.s3_bucket_lb_write.json
}
