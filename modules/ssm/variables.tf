variable "name" { 
    type = string 
}

variable "db_username" { 
    type = string 
}

variable "db_password" { 
    type = string 
}

variable "db_name" { 
    type = string 
}

variable "db_host" { 
    type = string 
}

variable "salts" { 
    type = string 
} # WordPress salts

variable "tags" { 
    type = map(string)
    default = {} 
}
