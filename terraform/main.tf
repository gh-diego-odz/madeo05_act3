terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_ami" "frontend" {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "name"
    values = ["app-frontend-*"]
  }
}

data "aws_ami" "backend" {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "name"
    values = ["app-backend-*"]
  }
}

data "aws_ami" "mongo" {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "name"
    values = ["db-mongo-*"]
  }
}

module "network" {
  source               = "./modules/network"
  vpc_cidr             = var.vpc_cidr
  public_subnet_a_cidr = var.public_subnet_a_cidr
  public_subnet_b_cidr = var.public_subnet_b_cidr
  private_subnet_cidr  = var.private_subnet_cidr
  availability_zone_a                 = var.availability_zone_a
  availability_zone_b                 = var.availability_zone_b
}

module "security_groups" {
  source     = "./modules/security_groups"
  vpc_id     = module.network.vpc_id
}

module "iam" {
  source = "./modules/iam"
}

module "database_instance" {
  source               = "./modules/database_instance"
  ami_id               = data.aws_ami.mongo.id
  instance_type        = "t3.small"
  subnet_id            = module.network.private_subnet_id
  private_ip           = var.database_private_ip
  security_group_id    = module.security_groups.mongo_sg_id
  mongo_user           = var.mongo_user
  mongo_password       = var.mongo_password
  mongo_db             = var.mongo_db
  iam_instance_profile = module.iam.instance_profile_name
}

module "backend_instance" {
  source               = "./modules/backend_instance"
  ami_id               = data.aws_ami.backend.id
  instance_type        = "t3.small"
  subnet_id            = module.network.private_subnet_id
  private_ip           = var.backend_private_ip
  security_group_id    = module.security_groups.backend_sg_id
  mongo_host           = module.database_instance.private_ip
  mongo_user           = var.mongo_user
  mongo_password       = var.mongo_password
  mongo_db             = var.mongo_db
  iam_instance_profile = module.iam.instance_profile_name
}

module "frontend_instance" {
  source                = "./modules/frontend_instance"
  ami_id                = data.aws_ami.frontend.id
  instance_type         = "t3.small"
  subnet_id             = module.network.private_subnet_id
  private_ip            = var.frontend_private_ip
  security_group_id     = module.security_groups.frontend_sg_id
  backend_private_ip    = module.backend_instance.private_ip
  iam_instance_profile  = module.iam.instance_profile_name
}

module "load_balancer" {
  source                = "./modules/load_balancer"
  vpc_id                = module.network.vpc_id
  public_subnet_ids     = module.network.public_subnet_ids
  security_group_id     = module.security_groups.lb_sg_id
  frontend_instance_id  = module.frontend_instance.instance_id
}