resource "aws_instance" "tradeflow_database_instance" {
    ami                    = var.ami_id
    instance_type          = var.instance_type
    subnet_id              = aws_subnet.database_subnet_a.id
    vpc_security_group_ids = [aws_security_group.database_sg.id]
    key_name               = var.key_name

    user_data = <<-EOF
                #!/bin/bash

                apt update -y
                apt install -y docker.io

                systemctl start docker
                systemctl enable docker

                docker run -d \
                    --name mongodb \
                    --restart unless-stopped \
                    -p ${var.mongodb_port}:27017 \
                    mongo
                EOF

    tags = {
        Name = "${var.project_name}-Database-Instance"
    }
}