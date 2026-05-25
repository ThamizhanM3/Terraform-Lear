# =========================
# Frontend Target Group
# =========================

resource "aws_lb_target_group" "frontend_target_group" {
    name        = "${var.project_name}-Frontend-TG"
    port        = var.frontend_port
    protocol    = "HTTP"
    target_type = "instance"
    vpc_id      = aws_vpc.tradeflow_vpc.id

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

# =========================
# Microservice 1 Target Group
# =========================

resource "aws_lb_target_group" "microservice_1_target_group" {
    name        = "${var.project_name}-MS1-TG"
    port        = var.microservice_1_port
    protocol    = "HTTP"
    target_type = "instance"
    vpc_id      = aws_vpc.tradeflow_vpc.id

    health_check {
        enabled             = true
        interval            = 30
        path                = "/health"
        protocol            = "HTTP"
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
        matcher             = "200"
    }

    tags = {
        Name = "${var.project_name}-MS1-TG"
    }
}

# =========================
# Microservice 2 Target Group
# =========================

resource "aws_lb_target_group" "microservice_2_target_group" {
    name        = "${var.project_name}-MS2-TG"
    port        = var.microservice_2_port
    protocol    = "HTTP"
    target_type = "instance"
    vpc_id      = aws_vpc.tradeflow_vpc.id

    health_check {
        enabled             = true
        interval            = 30
        path                = "/health"
        protocol            = "HTTP"
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
        matcher             = "200"
    }

    tags = {
        Name = "${var.project_name}-MS2-TG"
    }
}

# =========================
# Microservice 3 Target Group
# =========================

resource "aws_lb_target_group" "microservice_3_target_group" {
    name        = "${var.project_name}-MS3-TG"
    port        = var.microservice_3_port
    protocol    = "HTTP"
    target_type = "instance"
    vpc_id      = aws_vpc.tradeflow_vpc.id

    health_check {
        enabled             = true
        interval            = 30
        path                = "/health"
        protocol            = "HTTP"
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
        matcher             = "200"
    }

    tags = {
        Name = "${var.project_name}-MS3-TG"
    }
}

# =========================
# Microservice 4 Target Group
# =========================

resource "aws_lb_target_group" "microservice_4_target_group" {
    name        = "${var.project_name}-MS4-TG"
    port        = var.microservice_4_port
    protocol    = "HTTP"
    target_type = "instance"
    vpc_id      = aws_vpc.tradeflow_vpc.id

    health_check {
        enabled             = true
        interval            = 30
        path                = "/health"
        protocol            = "HTTP"
        timeout             = 5
        healthy_threshold   = 2
        unhealthy_threshold = 2
        matcher             = "200"
    }

    tags = {
        Name = "${var.project_name}-MS4-TG"
    }
}