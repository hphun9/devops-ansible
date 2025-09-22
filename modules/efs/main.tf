resource "aws_efs_file_system" "this" {
    encrypted = true
    tags = merge(var.tags, { Name = "${var.name}-efs" })
}

resource "aws_efs_mount_target" "mt" {
    for_each       = toset(var.private_subnet_ids)
    file_system_id = aws_efs_file_system.this.id
    subnet_id      = each.value
    security_groups = var.security_group_ids
}
