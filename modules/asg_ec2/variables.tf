variable "name" { 
    type = string 
}

variable "vpc_id" { 
    type = string 
}

variable "private_subnet_ids" { 
    type = list(string) 
}

variable "ec2_sg_id" { 
    type = string 
}

variable "key_name" { 
    type = string 
}

variable "instance_type" { 
    type = string 
}

variable "efs_file_system_id" { 
    type = string 
}

variable "tags" { 
    type = map(string)
    default = {} 
}
