variable "aws_profile" { 
    type = string
    default = "default" 
}

variable "region" { 
    type = string 
    default = "ap-southeast-1" 
}

variable "project" { 
    type = string
    default = "wp-ha" 
}

variable "env" { 
    type = string
    default = "dev" 

}

variable "vpc_cidr" { 
    type = string 
}

variable "public_subnets" { 
    type = list(string) 
}

variable "private_subnets" { 
    type = list(string) 
}

variable "key_name" { 
    type = string 
} # EC2 key pair name

variable "instance_type" { 
    type = string
    default = "t3.small" 
}

variable "db_engine" { 
    type = string
    default = "mysql" 
}

variable "db_engine_ver" { 
    type = string
    default = "8.0" 
}

variable "db_instance" { 
    type = string
    default = "db.t3.small" 
}

variable "db_name" { 
    type = string
    default = "wordpress" 
}

variable "db_username" { 
    type = string
    default = "wp_user" 
}

variable "alb_allowed_cidrs" { 
    type = list(string)
    default = ["0.0.0.0/0"] 
}
