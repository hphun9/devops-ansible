resource "aws_lb" "this" {
    name               = "${var.name}-alb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [var.alb_sg_id]
    subnets            = var.public_subnet_ids
    tags = merge(var.tags, { Name = "${var.name}-alb" })
}

resource "aws_lb_target_group" "tg" {
    name     = "${var.name}-tg"
    port     = var.target_group_port
    protocol = "HTTP"
    vpc_id   = var.target_group_vpc_id
    health_check {
        path = "/"
        matcher = "200-399"
    }
    tags = merge(var.tags, { Name = "${var.name}-tg" })
}

resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.this.arn
    port              = 80
    protocol          = "HTTP"
    default_action { 
        type = "forward"
        target_group_arn = aws_lb_target_group.tg.arn 
    }
}

resource "aws_autoscaling_attachment" "asg" {
    autoscaling_group_name = var.asg_target_id
    lb_target_group_arn    = aws_lb_target_group.tg.arn
}
