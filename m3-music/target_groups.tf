resource "aws_lb_target_group" "frontend_target_group" {
    name        = "${var.project_name}-Frontend-TG"
    port        = var.frontend_port
    protocol    = "HTTP"
    target_type = "instance"
    vpc_id      = aws_vpc.main.id

    health_check {
        enabled             = true
        interval            = 30
        path                = "/"
        protocol            = "HTTP"
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
        matcher             = "200"
    }

    tags = {
        Name = "${var.project_name}-Frontend-TG"
    }
}