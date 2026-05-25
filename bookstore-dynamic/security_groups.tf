locals {
    security_groups = {
        bastion = {
            description = "Bastion SG"
        }
        frontend_lb = {
            description = "Frontend LB SG"
        }
        frontend = {
            description = "Frontend Instance SG"
        }
        backend_lb = {
            description = "Backend LB SG"
        }
        backend = {
            description = "Backend Instance SG"
        }
        database = {
            description = "Database SG"
        }
    }
}

resource "aws_security_group" "sg" {
    for_each = local.security_groups
    name = "${var.project_name}-${each.key}"
    description = each.value.description
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "${var.project_name}-${each.key}"
    }
}

resource "aws_security_group_rule" "bastion_ssh" {
    type = "ingress"
    from_port = 22
    to_port   = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.sg["bastion"].id
}

resource "aws_security_group_rule" "frontend_from_lb" {
    type = "ingress"
    from_port = 80
    to_port   = 80
    protocol = "tcp"
    source_security_group_id = aws_security_group.sg["frontend_lb"].id
    security_group_id = aws_security_group.sg["frontend"].id
}