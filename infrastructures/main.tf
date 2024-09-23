terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "devops-interview-task-bucket"
    key    = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "task-tf-remote-state-lock"
  }
}

provider "aws" {
  region = "us-east-1"
}

module "network" {
  source = "./modules/network"

  vpc_cidr             = var.vpc_cidr
  private_subnetA_cidr = var.private_subnetA_cidr
  private_subnetB_cidr = var.private_subnetB_cidr
  public_subnetA_cidr  = var.public_subnetA_cidr
  public_subnetB_cidr  = var.public_subnetB_cidr
  az-a                 = var.az-a
  az-b                 = var.az-b
  env                  = var.env
}

module "instances" {
  source = "./modules/instances"

  vpc_id          = module.network.vpc_id
  instance_sg     = module.network.instance_sg
  lb_sg           = module.network.lb_sg
  instance_type   = var.instance_type
  private_subnetA = module.network.private_subnetA
  private_subnetB = module.network.private_subnetB
  public_subnetA  = module.network.public_subnetA
  public_subnetB  = module.network.public_subnetB
  bucket_prefix   = var.bucket_prefix
  logs_bucket     = module.s3.logs_bucket
  key_name        = var.key_name
  env             = var.env
}

module "s3" {                              # This module should be added if access_logs is enabled on the application load balancer
  source = "./modules/s3"

  logs_bucket = var.logs_bucket
}