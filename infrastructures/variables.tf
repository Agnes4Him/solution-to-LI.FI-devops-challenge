variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "env" {
  type    = string
  default = "task"
}

variable "private_subnetA_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "private_subnetB_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "public_subnetA_cidr" {
  type    = string
  default = "10.0.3.0/24"
}

variable "public_subnetB_cidr" {
  type    = string
  default = "10.0.4.0/24"
}

variable "az-a" {
  type    = string
  default = "us-east-1a"
}

variable "az-b" {
  type    = string
  default = "us-east-1b"
}

variable "instance_type" {
  type    = string
  default = "t2.medium"
}

variable "key_name" {
  type    = string
  default = "task_key"
}

variable "bucket_prefix" {
  type    = string
  default = "task/access-logs"
}

variable "logs_bucket" {
  type    = string
  default = "task-elb-access-log-bucket"
}

