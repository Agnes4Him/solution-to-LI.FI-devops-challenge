variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "env" {
  type    = string
  default = "task"
}

variable "instance_subnet" {
  type    = string
  default = ""
}

variable "instance_type" {
  type    = string
  default = "t2.small"
}

variable "key_pair_name" {
  type    = string
  default = "task_key"
}

/*variable "instance_subnets" {
  type = map(string)
  default = {
    "a" = "10.0.3.0/24",
    "b" = "10.0.4.0/24"
  }
}*/