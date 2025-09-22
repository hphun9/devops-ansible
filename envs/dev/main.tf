locals {
  name = "${var.project}-${var.env}"
  tags = {
    Project = var.project
    Env     = var.env
    Owner   = "sre"
  }
}

module "vpc" {
  source          = "../../modules/vpc"
  name            = local.name
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  tags            = local.tags
}

module "security" {
  source = "../../modules/security"
  name   = local.name
  vpc_id = module.vpc.vpc_id
  alb_sg_ingress_cidrs = var.alb_allowed_cidrs
  tags  = local.tags
}

module "efs" {
  source         = "../../modules/efs"
  name           = local.name
  vpc_id         = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  security_group_ids = [module.security.ec2_sg_id]
  tags = local.tags
}

module "rds" {
  source            = "../../modules/rds"
  name              = local.name
  vpc_id            = module.vpc.vpc_id
  private_subnet_ids= module.vpc.private_subnet_ids
  db_engine         = var.db_engine
  db_engine_ver     = var.db_engine_ver
  db_instance       = var.db_instance
  db_name           = var.db_name
  db_username       = var.db_username
  ec2_sg_id         = module.security.ec2_sg_id
  tags              = local.tags
}

module "ssm" {
  source      = "../../modules/ssm"
  name        = local.name
  db_username = var.db_username
  db_password = module.rds.db_password
  db_name     = var.db_name
  db_host     = module.rds.db_endpoint
  salts       = random_password.salts.result
  tags        = local.tags
}

resource "random_password" "salts" {
  length  = 64
  special = true
}

module "asg" {
  source = "../../modules/asg_ec2"
  name   = local.name
  vpc_id = module.vpc.vpc_id

  private_subnet_ids = module.vpc.private_subnet_ids
  ec2_sg_id          = module.security.ec2_sg_id
  key_name           = var.key_name
  instance_type      = var.instance_type
  efs_file_system_id = module.efs.efs_id
  tags               = local.tags
}

module "alb" {
  source              = "../../modules/alb"
  name                = local.name
  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.vpc.public_subnet_ids
  alb_sg_id           = module.security.alb_sg_id
  target_group_port   = 80
  target_group_vpc_id = module.vpc.vpc_id
  asg_target_id       = module.asg.asg_arn
  tags                = local.tags
}
