data "aws_ami" "task_ubuntu_ami" {           # Fetch AMI for launch template
  most_recent = true
  owners = ["099720109477"]
 
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
 
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
 
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}


resource "aws_launch_template" "task_LT" {        # Launch template for instances
  name_prefix     = "task"
  image_id        = data.aws_ami.task_ubuntu_ami.id
  instance_type   = var.instance_type
  network_interfaces {
    device_index = 0
    security_groups = [var.instance_sg]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.env}-instance-LT"
    }
  }
  user_data = filebase64("${path.module}/script.sh")
}

resource "aws_lb_target_group"  "task_target_group" {            # Define target group for ALB to route traffic to
  name = "task-target-group"
  target_type = "instance"
  port = 8085
  protocol = "HTTP"
  vpc_id = var.vpc_id

  health_check {
    healthy_threshold = 5
    unhealthy_threshold = 2
    interval = 30
    timeout = 5
    path = "/"
  }
}

resource "aws_autoscaling_group" "task_ASG" {                      # Autoscaling group for scaling in and out the instances
  name                  = "task-autoscaling-group"  
  desired_capacity      = 1
  max_size              = 2
  min_size              = 1
  #health_check_type     = "EC2"
  #termination_policies  = ["OldestInstance"]
  vpc_zone_identifier   = [var.private_subnetA, var.private_subnetB]
  target_group_arns = [aws_lb_target_group.task_target_group.arn]

  launch_template {
    id = aws_launch_template.task_LT.id
    version = "$Latest"
  }
}

resource "aws_lb"  "task_LB" {                                   # Application LoadBalancer to route traffic to the instances
  name = "task-loadbalancer"
  internal = false
  load_balancer_type = "application"
  security_groups = [var.lb_sg]
  subnets = [var.public_subnetA, var.public_subnetB]
  idle_timeout = 10
  client_keep_alive = 60
  access_logs {                                                   # S3 bucket for Load Balancer to write access logs to. Add this block if you wish to send logs to S3 for monitoring
    bucket  = var.logs_bucket
    prefix  = var.access_bucket_prefix
    enabled = true
  }
  connection_logs {                                                # S3 bucket for Load Balancer to write connection logs to. Add this block if you wish to send logs to S3 for monitoring
    bucket  = var.logs_bucket
    prefix  = var.conn_bucket_prefix
    enabled = true
  }
}

resource "aws_lb_listener"  "task_alb_listener" {                 # Application LoadBalancer listeners
  load_balancer_arn = aws_lb.task_LB.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.task_target_group.arn
  }
}

resource "aws_autoscaling_policy" "scale_down_policy" {            # Policy to define criteria for scaling down instance count
  name                   = "scale-down"
  autoscaling_group_name = aws_autoscaling_group.task_ASG.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 120
}

resource "aws_autoscaling_policy" "scale_up_policy" {               # Policy to define criteria for scaling up instance count
  name                   = "scale-up"
  autoscaling_group_name = aws_autoscaling_group.task_ASG.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 120
}


resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {          # Cloud watch alarm to trigger scaling down
  alarm_description   = "Monitors Instances CPU utilization"
  alarm_actions       = [aws_autoscaling_policy.scale_down_policy.arn]
  alarm_name          = "scale_down_alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "25"
  evaluation_periods  = "5"
  period              = "30"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.task_ASG.name
  }
}

resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {              # Cloud watch alarm to trigger scaling up
  alarm_description   = "Monitors Instances CPU utilization"
  alarm_actions       = [aws_autoscaling_policy.scale_up_policy.arn]
  alarm_name          = "scale_up_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "75"
  evaluation_periods  = "5"
  period              = "30"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.task_ASG.name
  }
}