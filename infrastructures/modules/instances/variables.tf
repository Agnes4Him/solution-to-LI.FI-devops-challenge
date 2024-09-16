variable "env" {
  type    = string
  default = "task"
}

variable "instance_type" {
  type    = string
  default = ""
}

variable "key_pair_name" {
  type    = string
  default = ""
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "instance_sg" {
  type    = string
  default = ""
}

variable "lb_sg" {
  type    = string
  default = ""
}

variable "private_subnetA" {
  type    = string
  default = ""
}

variable "private_subnetB" {
  type    = string
  default = ""
}

variable "public_subnetA" {
  type    = string
  default = ""
}

variable "public_subnetB" {
  type    = string
  default = ""
}

/*variable "instance_subnets" {
  type = map(string)
}*/