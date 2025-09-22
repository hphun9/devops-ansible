variable "name" { 
    type = string 
}

variable "vpc_id" { 
    type = string 
}

variable "private_subnet_ids" { 
    type = list(string) 
}

variable "db_engine" { 
    type = string 
}

variable "db_engine_ver" { 
    type = string 
}

variable "db_instance" { 
    type = string 
}

variable "db_name" { 
    type = string 
}

variable "db_username" { 
    type = string 
}

variable "ec2_sg_id" { 
    type = string 
}

variable "tags" { 
    type = map(string)
    default = {} 
}
