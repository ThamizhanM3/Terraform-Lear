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

resource "aws_instance" "backend_instance" {
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = aws_subnet.backend_subnet_a.id
    security_groups = [ aws_security_group.backend_sg.id ]
    key_name = "M3"

    user_data = base64encode(<<-EOF
                #!/bin/bash

                apt update -y
                apt install -y docker.io

                systemctl start docker
                systemctl enable docker

                docker run -d \
                    --name backend \
                    --restart unless-stopped \
                    -e PORT=${var.backend_port} \
                    -e MONGODB_URI=mongodb://${aws_instance.database_instance.private_ip}:${var.database_port}/m3-music \
                    -e JWT_SECRET=your_super_secret_jwt_key_here \
                    -e AWS_REGION=${var.aws_region} \
                    -e S3_BUCKET_NAME=${your_bucket_name} \
                    -e S3_PUBLIC_URL=${"https://your-bucket.s3.ap-south-1.amazonaws.com"} \
                    -p ${var.backend_port}:${var.backend_port} \
                    ${var.backend_image}
                EOF
    )

    tags = {
        Name = "${var.project_name}-Backend-Instance"
    }
}

resource "aws_instance" "frontend_instance" {
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = aws_subnet.frontend_subnet_a.id
    security_groups = [ aws_security_group.frontend_sg.id ]
    key_name = "M3"

    user_data = base64encode(<<-EOF
                #!/bin/bash

                apt update -y
                apt install -y docker.io

                systemctl start docker
                systemctl enable docker

                docker run -d \
                    --name frontend \
                    --restart unless-stopped \
                    -e VITE_API_URL=${aws_instance.backend_instance.private_ip} \
                    -p ${var.frontend_port}:${var.frontend_port} \
                    ${var.frontend_image}
                EOF
    )

    tags = {
        Name = "${var.project_name}-Frontend-Instance"
    }
}