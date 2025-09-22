output "alb_dns_name" { 
  value = module.alb.alb_dns_name 
}

output "rds_endpoint" { 
  value = module.rds.db_endpoint 
}

output "efs_id" { 
  value = module.efs.efs_id 
}

output "asg_name" { 
  value = module.asg.asg_name 
}