resource "aws_lb" "frontend_alb" {
    name               = "${var.project_name}-Frontend-ALB"
    internal           = false
    load_balancer_type = "application"

    security_groups = [
        aws_security_group.frontend_alb_sg.id
    ]

    subnets = [
        aws_subnet.bastionhost_subnet_a.id,
        aws_subnet.bastionhost_subnet_b.id
    ]

    tags = {
        Name = "${var.project_name}-Frontend-ALB"
    }
}

resource "aws_lb_listener" "frontend_listener" {
    load_balancer_arn = aws_lb.frontend_alb.arn
    port              = 80
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.frontend_target_group.arn
    }
}