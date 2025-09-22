data "aws_ami" "al2" {
    most_recent = true
    owners      = ["amazon"]
    filter { 
        name = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"] 
    }
}

resource "aws_iam_role" "ec2" {
    name               = "${var.name}-ec2-role"
    assume_role_policy = data.aws_iam_policy_document.ec2_trust.json
}

data "aws_iam_policy_document" "ec2_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals { 
        type = "Service"
        identifiers = ["ec2.amazonaws.com"] 
    }
  }
}

resource "aws_iam_role_policy_attachment" "ssm" {
    role       = aws_iam_role.ec2.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
resource "aws_iam_role_policy_attachment" "efs" {
    role       = aws_iam_role.ec2.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientReadWriteAccess"
}
resource "aws_iam_instance_profile" "this" {
    name = "${var.name}-ec2-profile"
    role = aws_iam_role.ec2.name
}

locals {
    rendered_user_data = templatefile("${path.module}/user_data.sh", { efs_id = var.efs_file_system_id })
}

resource "aws_launch_template" "lt" {
    name_prefix   = "${var.name}-lt-"
    image_id      = data.aws_ami.al2.id
    instance_type = var.instance_type
    key_name      = var.key_name
    user_data     = base64encode(local.rendered_user_data)

    iam_instance_profile { name = aws_iam_instance_profile.this.name }
    network_interfaces {
        security_groups = [var.ec2_sg_id]
    }
    tag_specifications {
        resource_type = "instance"
        tags = merge(var.tags, {
        Name = "${var.name}-wp"
        Role = "wordpress"
        })
    }
}

resource "aws_autoscaling_group" "asg" {
    name                = "${var.name}-asg"
    min_size            = 2
    max_size            = 4
    desired_capacity    = 2
    vpc_zone_identifier = var.private_subnet_ids
    health_check_type   = "EC2"
    launch_template { 
        id = aws_launch_template.lt.id
        version = "$Latest" 
    }
    tag { 
        key = "Name" 
        value = "${var.name}-wp" 
        propagate_at_launch = true 
    }
    tag { 
        key = "Role" 
        value = "wordpress" 
        propagate_at_launch = true 
    }
}
