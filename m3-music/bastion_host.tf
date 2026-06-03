resource "aws_instance" "bastionhost_instance" {
    ami                    = var.ami_id
    instance_type          = var.instance_type
    subnet_id              = aws_subnet.bastionhost_subnet_a.id
    vpc_security_group_ids = [aws_security_group.bastionhost_sg.id]
    key_name               = var.key_name

    associate_public_ip_address = true

    tags = {
        Name = "${var.project_name}-BastionHost-Instance"
    }
}