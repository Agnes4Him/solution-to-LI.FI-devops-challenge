variable "ami_id" {
  type    = string
  default = ""
}

variable "instance_subnet" {
  type    = string
  default = ""
}

variable "instance_type" {
  type    = string
  default = ""
}

variable "key_pair_name" {
  type    = string
  default = ""
}

variable "instance_sg" {
  type    = string
  default = ""
}

variable "instance_subnets" {
  type = map(string)
}