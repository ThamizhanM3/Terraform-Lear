resource "aws_security_group" "bastionhost_sg" {
    name        = "${var.project_name}-BastionHost-SG"
    description = "Security group for Bastion Host"
    vpc_id      = aws_vpc.main.id

    ingress {
        description = "SSH from anywhere"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.project_name}-BastionHost-SG"
    }
}

resource "aws_security_group" "private_instance_sg" {
    name        = "${var.project_name}-PrivateInstance-SG"
    description = "Security group for Private Instance"
    vpc_id      = aws_vpc.main.id

    ingress {
        description = "SSH from bastion host"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        security_groups = [ aws_security_group.bastionhost_sg.id ]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.project_name}-PrivateInstance-SG"
    }
}