variable "vpc_cidr" {
  type    = string
  default = ""
}

variable "env" {
  type    = string
  default = ""
}

variable "private_subnetA_cidr" {
  type    = string
  default = ""
}

variable "private_subnetB_cidr" {
  type    = string
  default = ""
}

variable "public_subnetA_cidr" {
  type    = string
  default = ""
}

variable "public_subnetB_cidr" {
  type    = string
  default = ""
}

variable "az-a" {
  type    = string
  default = ""
}

variable "az-b" {
  type    = string
  default = ""
}
