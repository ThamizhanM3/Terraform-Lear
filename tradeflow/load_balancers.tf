# =========================
# Frontend Public Load Balancer
# =========================

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

# =========================
# Frontend ALB Listener
# =========================

resource "aws_lb_listener" "frontend_listener" {
    load_balancer_arn = aws_lb.frontend_alb.arn
    port              = 80
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.frontend_target_group.arn
    }
}

# =========================
# Internal Backend Load Balancer
# =========================

resource "aws_lb" "backend_alb" {
    name               = "${var.project_name}-Backend-ALB"
    internal           = true
    load_balancer_type = "application"

    security_groups = [
        aws_security_group.backend_alb_sg.id
    ]

    subnets = [
        aws_subnet.backend_subnet_a.id,
        aws_subnet.backend_subnet_b.id
    ]

    tags = {
        Name = "${var.project_name}-Backend-ALB"
    }
}

# =========================
# Backend ALB Listener
# =========================

resource "aws_lb_listener" "backend_listener" {
    load_balancer_arn = aws_lb.backend_alb.arn
    port              = 80
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.microservice_1_target_group.arn
    }
}

# =========================
# Listener Rule - Microservice 1
# =========================

resource "aws_lb_listener_rule" "microservice_1_rule" {
    listener_arn = aws_lb_listener.backend_listener.arn
    priority     = 100

    action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.microservice_1_target_group.arn
    }

    condition {
        path_pattern {
            values = ["/api/users/*"]
        }
    }
}

# =========================
# Listener Rule - Microservice 2
# =========================

resource "aws_lb_listener_rule" "microservice_2_rule" {
    listener_arn = aws_lb_listener.backend_listener.arn
    priority     = 101

    action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.microservice_2_target_group.arn
    }

    condition {
        path_pattern {
            values = ["/api/stocks/*"]
        }
    }
}

# =========================
# Listener Rule - Microservice 3
# =========================

resource "aws_lb_listener_rule" "microservice_3_rule" {
    listener_arn = aws_lb_listener.backend_listener.arn
    priority     = 102

    action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.microservice_3_target_group.arn
    }

    condition {
        path_pattern {
            values = ["/api/trades/*"]
        }
    }
}

# =========================
# Listener Rule - Microservice 4
# =========================

resource "aws_lb_listener_rule" "microservice_4_rule" {
    listener_arn = aws_lb_listener.backend_listener.arn
    priority     = 103

    action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.microservice_4_target_group.arn
    }

    condition {
        path_pattern {
            values = ["/api/portfolio/*"]
        }
    }
}