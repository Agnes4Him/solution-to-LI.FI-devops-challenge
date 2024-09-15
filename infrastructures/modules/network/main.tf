resource "aws_vpc" "demo_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_tag
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.demo_vpc.id

  tags = {
    Name = var.igw_tag
  }
}

resource "aws_subnet" "private_subnetA" {
  vpc_id            = aws_vpc.demo_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    "Name" = "private-${var.subnet_tag}-a"
  }
}

resource "aws_subnet" "private_subnetB" {
  vpc_id            = aws_vpc.demo_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    "Name" = "private-${var.subnet_tag}-b"
  }
}

resource "aws_subnet" "public_subnetA" {
  vpc_id                  = aws_vpc.demo_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "public-${var.subnet_tag}-a"
  }
}

resource "aws_subnet" "public_subnetB" {
  vpc_id                  = aws_vpc.demo_vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "public-${var.subnet_tag}-b"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = var.eip_tag
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnetA.id

  tags = {
    Name = var.nat_tag
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private_RT" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "private-${var.rt_tag}"
  }
}

resource "aws_route_table" "public_RT" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-${var.rt_tag}"
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
  description = "Allow HTTP/HTTPS traffic to web server"
  vpc_id      = aws_vpc.demo_vpc.id

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
}

resource "aws_security_group" "db_sg" {
  name        = "database_sg"
  description = "Allow traffic from web server"
  vpc_id      = aws_vpc.demo_vpc.id

  ingress {
    description = "ingress from web service"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_security_group.instance_sg.id]
  }
}
