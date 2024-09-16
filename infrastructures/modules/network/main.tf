resource "aws_vpc" "task_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "${var.env}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.task_vpc.id

  tags = {
    Name = "${var.env}-igw"
  }
}

resource "aws_subnet" "private_subnetA" {
  vpc_id            = aws_vpc.task_vpc.id
  cidr_block              = var.private_subnetA_cidr
  availability_zone = var.az-a

  tags = {
    "Name" = "${var.env}-private-subnetA"
  }
}

resource "aws_subnet" "private_subnetB" {
  vpc_id            = aws_vpc.task_vpc.id
  cidr_block        = var.private_subnetB_cidr
  availability_zone = var.az-b

  tags = {
    "Name" = "${var.env}-private-subnetB"
  }
}

resource "aws_subnet" "public_subnetA" {
  vpc_id                  = aws_vpc.task_vpc.id
  cidr_block              = var.public_subnetA_cidr
  availability_zone       = var.az-a

  tags = {
    "Name" = "${var.env}-public-subnetA"
  }
}

resource "aws_subnet" "public_subnetB" {
  vpc_id                  = aws_vpc.task_vpc.id
  cidr_block              = var.public_subnetB_cidr
  availability_zone       = var.az-b

  tags = {
    "Name" = "${var.env}-public-subnetB"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${var.env}-eip"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnetA.id

  tags = {
    Name = "${var.env}-nat"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private_RT" {
  vpc_id = aws_vpc.task_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "${var.env}-private-RT"
  }
}

resource "aws_route_table" "public_RT" {
  vpc_id = aws_vpc.task_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.env}-public-RT"
  }
}

resource "aws_route_table_association" "private_RT_associationA" {
  subnet_id      = aws_subnet.private_subnetA.id
  route_table_id = aws_route_table.private_RT.id
}

resource "aws_route_table_association" "private_RT_associationB" {
  subnet_id      = aws_subnet.private_subnetB.id
  route_table_id = aws_route_table.private_RT.id
}

resource "aws_route_table_association" "public_RT_associationA" {
  subnet_id      = aws_subnet.public_subnetA.id
  route_table_id = aws_route_table.public_RT.id
}

resource "aws_route_table_association" "public_RT_associationB" {
  subnet_id      = aws_subnet.public_subnetB.id
  route_table_id = aws_route_table.public_RT.id
}

resource "aws_security_group" "instance_sg" {
  name        = "instance_sg"
  description = "Allow traffic from and to Application LoadBalancer"
  vpc_id      = aws_vpc.task_vpc.id

  ingress {
    description = "Ingress from LoadBalancer"
    from_port   = 4201
    to_port     = 4201
    protocol    = "tcp"
    cidr_blocks = [aws_security_group.lb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_security_group.lb_sg.id]
  }

  tags = {
    Name = "${var.env}-instance-sg"
  }
}

resource "aws_security_group" "lb_sg" {
  name        = "loadbalancer_sg"
  description = "Allow HTTP/HTTPS traffic from the internet to Application Loadbalancer"
  vpc_id      = aws_vpc.task_vpc.id

  ingress {
    description = "HTTPS ingress"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-lb-sg"
  }
}
