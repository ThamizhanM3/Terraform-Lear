resource "aws_instance" "database_instance" {
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = aws_subnet.database_subnet_a.id
    security_groups = [ aws_security_group.database_sg.id ]
    key_name = "M3"

    depends_on = [
        aws_nat_gateway.nat_gateway
    ]

    user_data = <<-EOF
                #!/bin/bash

                apt update -y
                apt install -y docker.io

                systemctl start docker
                systemctl enable docker

                docker run -d \
                    --name mongodb \
                    --restart unless-stopped \
                    -p 27017:27017 \
                    mongo
                EOF
    tags = {
        Name = "${var.project_name}-Database-Instance"
    }
}