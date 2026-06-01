resource "aws_instance" "bastion_host" {
    ami                    = var.ami_id
    instance_type          = var.instance_type
    subnet_id              = aws_subnet.public_subnet.id
    vpc_security_group_ids = [aws_security_group.bastionhost_sg.id]
    key_name               = var.key_name

    associate_public_ip_address = true

    tags = {
        Name = "${var.project_name}-BastionHost-Instance"
    }
}

resource "aws_instance" "private_instance" {
    ami                    = var.ami_id
    instance_type          = var.instance_type
    subnet_id              = aws_subnet.private_subnet.id
    vpc_security_group_ids = [aws_security_group.private_instance_sg.id]
    key_name               = var.key_name

    tags = {
        Name = "${var.project_name}-Private-Instance"
    }
}