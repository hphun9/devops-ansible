resource "random_password" "db" { 
    length = 20
    special = true 
}

resource "aws_db_subnet_group" "this" {
    name       = "${var.name}-db-subnet"
    subnet_ids = var.private_subnet_ids
    tags       = merge(var.tags, { Name = "${var.name}-db-subnet" })
}

resource "aws_db_instance" "this" {
    identifier              = "${var.name}-db"
    engine                  = var.db_engine
    engine_version          = var.db_engine_ver
    instance_class          = var.db_instance
    username                = var.db_username
    password                = random_password.db.result
    db_name                 = var.db_name
    allocated_storage       = 20
    multi_az                = true
    storage_encrypted       = true
    skip_final_snapshot     = true
    db_subnet_group_name    = aws_db_subnet_group.this.name
    vpc_security_group_ids  = [var.ec2_sg_id]
    publicly_accessible     = false
    deletion_protection     = false
    backup_retention_period = 7
    apply_immediately       = true
    tags = merge(var.tags, { Name = "${var.name}-db" })
}
