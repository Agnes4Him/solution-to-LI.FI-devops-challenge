/*resource "aws_instance" "demo_instance" {
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
}*/

data "aws_ami" "task_ubuntu_ami" {
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


resource "aws_launch_template" "task_LT" {
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

resource "aws_lb_target_group"  "task_target_group" {
  name = "task-target-group"
  port = 4201
  protocol = "HTTP"
  vpc_id = var.vpc_id

  health_check {
    path = "/"
    matcher = 200
  }
}

resource "aws_autoscaling_group" "task_ASG" {
  name                  = "task-autoscaling-group"  
  desired_capacity      = 1
  max_size              = 3
  min_size              = 1
  health_check_type     = "EC2"
  termination_policies  = ["OldestInstance"]
  vpc_zone_identifier   = [var.private_subnetA, var.private_subnetB]
  target_group_arns = [aws_lb_target_group.task_target_group.arn]

  launch_template {
    id = aws_launch_template.task_LT.id
    version = "$Latest"
  }
}

resource "aws_lb"  "task_LB" {
  name = "task-loadbalancer"
  internal = false
  load_balancer_type = "application"
  security_groups = [var.lb_sg]
  subnets = [var.public_subnetA, var.public_subnetB]
}

resource "aws_lb_listener"  "task_alb_listener" {
  load_balancer_arn = aws_lb.task_LB.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.task_target_group.arn
  }
}

resource "aws_autoscaling_policy" "scale_down_policy" {
  name                   = "scale-down"
  autoscaling_group_name = aws_autoscaling_group.task_ASG.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 120
}

resource "aws_autoscaling_policy" "scale_up_policy" {
  name                   = "scale-up"
  autoscaling_group_name = aws_autoscaling_group.task_ASG.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 120
}


resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
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

resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
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