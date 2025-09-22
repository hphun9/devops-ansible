locals { 
    prefix = "/${var.name}/wordpress" 
}

resource "aws_ssm_parameter" "db_user" { 
    name = "${local.prefix}/db_user" 
    type = "String" 
    value = var.db_username 
}

resource "aws_ssm_parameter" "db_pass" { 
    name = "${local.prefix}/db_pass" 
    type = "SecureString" 
    value = var.db_password 
}

resource "aws_ssm_parameter" "db_name" { 
    name = "${local.prefix}/db_name" 
    type = "String" 
    value = var.db_name 
}

resource "aws_ssm_parameter" "db_host" { 
    name = "${local.prefix}/db_host" 
    type = "String" 
    value = var.db_host 
}

resource "aws_ssm_parameter" "salts" { 
    name = "${local.prefix}/salts"   
    type = "SecureString" 
    value = var.salts 
}
