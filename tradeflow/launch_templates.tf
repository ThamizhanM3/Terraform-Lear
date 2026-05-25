resource "aws_launch_template" "frontend_launch_template" {
    name_prefix   = "${var.project_name}-Frontend-LT-"
    image_id      = var.ami_id
    instance_type = var.instance_type
    key_name      = var.key_name

    vpc_security_group_ids = [
        aws_security_group.frontend_sg.id
    ]

    user_data = base64encode(<<-EOF
                #!/bin/bash

                apt update -y
                apt install -y docker.io

                systemctl start docker
                systemctl enable docker

                docker run -d \
                  --name frontend \
                  --restart unless-stopped \
                  -p ${var.frontend_port}:${var.frontend_port} \
                  ${var.frontend_docker_image}
                EOF
    )

    tag_specifications {
        resource_type = "instance"

        tags = {
            Name = "${var.project_name}-Frontend-Instance"
        }
    }
}

resource "aws_launch_template" "backend_1_launch_template" {
    name_prefix   = "${var.project_name}-Backend1-LT-"
    image_id      = var.ami_id
    instance_type = var.instance_type
    key_name      = var.key_name

    vpc_security_group_ids = [
        aws_security_group.backend_sg.id
    ]

    user_data = base64encode(<<-EOF
                #!/bin/bash

                apt update -y
                apt install -y docker.io

                systemctl start docker
                systemctl enable docker

                docker run -d \
                  --name microservice-1 \
                  --restart unless-stopped \
                  -e PORT=${var.microservice_1_port} \
                  -e MONGODB_URI=mongodb://${aws_instance.tradeflow_database_instance.private_ip}:${var.mongodb_port} \
                  -p ${var.microservice_1_port}:${var.microservice_1_port} \
                  ${var.microservice_1_image}

                docker run -d \
                  --name microservice-2 \
                  --restart unless-stopped \
                  -e PORT=${var.microservice_2_port} \
                  -e MONGODB_URI=mongodb://${aws_instance.tradeflow_database_instance.private_ip}:${var.mongodb_port} \
                  -p ${var.microservice_2_port}:${var.microservice_2_port} \
                  ${var.microservice_2_image}
                EOF
    )

    tag_specifications {
        resource_type = "instance"

        tags = {
            Name = "${var.project_name}-Backend1-Instance"
        }
    }
}

resource "aws_launch_template" "backend_2_launch_template" {
    name_prefix   = "${var.project_name}-Backend2-LT-"
    image_id      = var.ami_id
    instance_type = var.instance_type
    key_name      = var.key_name

    vpc_security_group_ids = [
        aws_security_group.backend_sg.id
    ]

    user_data = base64encode(<<-EOF
                #!/bin/bash

                apt update -y
                apt install -y docker.io

                systemctl start docker
                systemctl enable docker

                docker run -d \
                  --name microservice-3 \
                  --restart unless-stopped \
                  -e PORT=${var.microservice_3_port} \
                  -e MONGODB_URI=mongodb://${aws_instance.tradeflow_database_instance.private_ip}:${var.mongodb_port} \
                  -p ${var.microservice_3_port}:${var.microservice_3_port} \
                  ${var.microservice_3_image}

                docker run -d \
                  --name microservice-4 \
                  --restart unless-stopped \
                  -e PORT=${var.microservice_4_port} \
                  -e MONGODB_URI=mongodb://${aws_instance.tradeflow_database_instance.private_ip}:${var.mongodb_port} \
                  -p ${var.microservice_4_port}:${var.microservice_4_port} \
                  ${var.microservice_4_image}
                EOF
    )

    tag_specifications {
        resource_type = "instance"

        tags = {
            Name = "${var.project_name}-Backend2-Instance"
        }
    }
}