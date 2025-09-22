resource "aws_security_group" "alb" {
    name   = "${var.name}-alb-sg"
    vpc_id = var.vpc_id
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = var.alb_sg_ingress_cidrs
    }
    egress { 
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"] 
    }

    tags = merge(var.tags, { Name = "${var.name}-alb-sg" })
}

resource "aws_security_group" "ec2" {
    name   = "${var.name}-ec2-sg"
    vpc_id = var.vpc_id
    ingress { 
        from_port = 80 
        to_port = 80 
        protocol = "tcp" 
        security_groups = [aws_security_group.alb.id] 
    }
    ingress { 
        from_port = 2049 
        to_port = 2049 
        protocol = "tcp" 
        cidr_blocks = ["10.0.0.0/8"] 
    }
    egress  { 
        from_port = 0 
        to_port = 0 
        protocol = "-1" 
        cidr_blocks = ["0.0.0.0/0"] 
    }
    tags = merge(var.tags, { Name = "${var.name}-ec2-sg" })
}

resource "aws_security_group" "rds" {
    name   = "${var.name}-rds-sg"
    vpc_id = var.vpc_id
    ingress { 
        from_port = 3306 
        to_port = 3306 
        protocol = "tcp" 
        security_groups = [aws_security_group.ec2.id] 
    }
    egress  { 
        from_port = 0 
        to_port = 0 
        protocol = "-1" 
        cidr_blocks = ["0.0.0.0/0"] 
    }
    tags = merge(var.tags, { Name = "${var.name}-rds-sg" })
}
