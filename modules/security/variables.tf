variable "name" { 
    type = string 
}

variable "vpc_id" { 
    type = string 
}

variable "alb_sg_ingress_cidrs" { 
    type = list(string) 
}

variable "tags" { 
    type = map(string)
    default = {} 
}
