variable "name" { 
    type = string 
}

variable "vpc_id" { 
    type = string 
}

variable "public_subnet_ids" { 
    type = list(string) 
}

variable "alb_sg_id" { 
    type = string 
}

variable "target_group_port" { 
    type = number 
}

variable "target_group_vpc_id" { 
    type = string 
}

variable "asg_target_id" { 
    type = string 
} # ASG ARN

variable "tags" { 
    type = map(string)
    default = {} 
}
