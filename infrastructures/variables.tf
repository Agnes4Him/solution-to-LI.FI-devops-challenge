variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "vpc_tag" {
  type    = string
  default = "demo_vpc"
}

variable "igw_tag" {
  type    = string
  default = "demo_igw"
}

variable "subnet_tag" {
  type    = string
  default = "demo_subnet"
}

variable "nat_tag" {
  type    = string
  default = "demo_nat"
}

variable "rt_tag" {
  type    = string
  default = "demo_RT"
}

variable "db_username" {
  type    = string
  default = ""
}

variable "db_password" {
  type    = string
  default = ""
}

variable "ami_id" {
  type    = string
  default = "ami-04e914639d0cca79a"
}

variable "instance_subnet" {
  type    = string
  default = ""
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "key_pair_name" {
  type    = string
  default = "demo_key"
}

variable "instance_subnets" {
  type = map(string)
  default = {
    "a" = "10.0.3.0/24",
    "b" = "10.0.4.0/24"
  }
}