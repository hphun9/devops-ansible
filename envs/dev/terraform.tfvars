aws_profile = "default"
region      = "ap-southeast-1"

project = "wp-ha"
env     = "dev"

vpc_cidr        = "10.20.0.0/16"
public_subnets  = ["10.20.1.0/24", "10.20.2.0/24"]
private_subnets = ["10.20.11.0/24", "10.20.12.0/24"]

key_name      = "TODO-keypair"
instance_type = "t3.small"

db_engine     = "mysql"
db_engine_ver = "8.0"
db_instance   = "db.t3.small"
db_name       = "wordpress"
db_username   = "wp_user"

alb_allowed_cidrs = ["0.0.0.0/0"]
