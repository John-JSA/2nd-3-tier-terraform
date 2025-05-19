# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}


module "vpc" {
  source                       = "./vpc"
  vpc_cidr_block               = var.vpc_cidr_block
  frontend_cidr_block          = var.frontend_cidr_block
  backend_cidr_block           = var.backend_cidr_block
  availability_zone            = var.availability_zone
  tags                         = local.project_tags
  apci_frontend_subnet_az2a_id = var.vpc_cidr_block
  apci_frontend_subnet_az2b_id = var.vpc_cidr_block
  apci_db_subnet_az2a_id = module.vpc.apci_db_subnet_az2a_id
  apci_db_subnet_az2b_id = module.vpc.apci_db_subnet_az2b_id
  apci_backend_subnet_az2a_id = module.vpc.apci_backend_subnet_az2a_id
}

module "alb" {
  source                       = "./alb"
  apci_frontend_subnet_az2a_id = module.vpc.apci_frontend_subnet_az2a_id
  apci_frontend_subnet_az2b_id = module.vpc.apci_frontend_subnet_az2b_id
  vpc_id                       = module.vpc.vpc_id
  tags                         = local.project_tags
}
#ssl_policy = var.ssl_policy
#certificate_arn = var.certificate_arn
#}


module "asg" {
  source                       = "./asg"
  tags                         = local.project_tags
  apci_alb_sg_id               = module.alb.apci_alb_sg_id
  vpc_id                       = module.vpc.vpc_id
  instance_type                = var.instance_type
  key_name                     = var.key_name
  image_id                     = var.image_id
  apci_frontend_subnet_az2a_id = module.vpc.apci_frontend_subnet_az2a_id
  apci_frontend_subnet_az2b_id = module.vpc.apci_frontend_subnet_az2b_id 
  apci_target_group_arn = module.alb.apci_target_group_arn
}

module "RDS" {
  source = "./RDS"
  apci_db_subnet_az2a_id = module.vpc.apci_db_subnet_az2a_id
  apci_db_subnet_az2b_id = module.vpc.apci_db_subnet_az2b_id
  tags                   = local.project_tags
  vpc_cidr_block         = var.vpc_cidr_block
  vpc_id                 = module.vpc.vpc_id
  region                 = var.region
  account_id             = var.account_id
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  db_username            = var.db_username 
parameter_group_name     = var.parameter_group_name
bastion_host_id = module.ec2.bastion_host_id

}

module "ec2" {
source = "./ec2"
apci_main_vpc_id = module.vpc.apci_main_vpc_id
apci_frontend_subnet_az2a_id = module.vpc.apci_frontend_subnet_az2a_id
apci_backend_subnet_az2b_id  = module.vpc.apci_backend_subnet_az2b_id
apci_backend_subnet_az2a_id  = module.vpc.apci_backend_subnet_az2a_id
ec2_ami                      = module.ec2.ec2_ami
bastion_sg_id                = module.ec2.aws_security_group.apci_bastion_sg.id
tags                         = local.project_tags
key_name                     = var.key_name
vpc_id                       = module.vpc.vpc_id
vpc_cidr_block               = module.vpc.cidr_block
instance_type                = var.instance_type
image_id = var.image_id
}

