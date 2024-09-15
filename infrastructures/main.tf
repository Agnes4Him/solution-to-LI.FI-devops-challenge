terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "devops-task-bucket"
    key    = "task-tf-state"
    region = "us-east-1"
    dynamodb_table = "task-tf-remote-state-lock"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "network" {
  source = "./modules.tf/vpc"

  vpc_cidr   = var.vpc_cidr
  vpc_tag    = var.vpc_tag
  igw_tag    = var.igw_tag
  subnet_tag = var.subnet_tag
  nat_tag    = var.nat_tag
  rt_tag     = var.rt_tag
}

module "instance" {
  source = "./modules.tf/instance"

  instance_sg      = module.vpc.instance_sg
  ami_id           = var.ami_id
  instance_type    = var.instance_type
  instance_subnets = var.instance_subnets
  key_pair_name    = var.key_pair_name
}
