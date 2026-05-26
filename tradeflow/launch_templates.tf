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

                apt install -y docker.io nginx

                systemctl start docker
                systemctl enable docker

                systemctl start nginx
                systemctl enable nginx

                docker run -d \
                  --name tradeflow-frontend \
                  --restart unless-stopped \
                  -p 3000:80 \
                  -e VITE_USERS_API="/api" \
                  -e VITE_STOCKS_API="/api" \
                  -e VITE_TRADES_API="/api" \
                  -e VITE_PORTFOLIO_API="/api" \
                  ${var.frontend_docker_image}

                cat > /etc/nginx/sites-available/default <<'NGINXCONF'
                server {

                    listen 80;

                    location / {

                        proxy_pass http://localhost:3000;

                        proxy_http_version 1.1;

                        proxy_set_header Host $host;
                        proxy_set_header X-Real-IP $remote_addr;
                        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                        proxy_set_header X-Forwarded-Proto $scheme;
                    }

                    location /api/users/ {

                        proxy_pass http://${aws_lb.backend_alb.dns_name};

                        proxy_http_version 1.1;

                        proxy_set_header Host $host;
                        proxy_set_header X-Real-IP $remote_addr;
                        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                        proxy_set_header X-Forwarded-Proto $scheme;
                    }

                    location /api/stocks/ {

                        proxy_pass http://${aws_lb.backend_alb.dns_name};

                        proxy_http_version 1.1;

                        proxy_set_header Host $host;
                        proxy_set_header X-Real-IP $remote_addr;
                        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                        proxy_set_header X-Forwarded-Proto $scheme;
                    }

                    location /api/trades/ {

                        proxy_pass http://${aws_lb.backend_alb.dns_name};

                        proxy_http_version 1.1;

                        proxy_set_header Host $host;
                        proxy_set_header X-Real-IP $remote_addr;
                        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                        proxy_set_header X-Forwarded-Proto $scheme;
                    }

                    location /api/portfolio/ {

                        proxy_pass http://${aws_lb.backend_alb.dns_name};

                        proxy_http_version 1.1;

                        proxy_set_header Host $host;
                        proxy_set_header X-Real-IP $remote_addr;
                        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                        proxy_set_header X-Forwarded-Proto $scheme;
                    }
                }
                NGINXCONF

                nginx -t

                systemctl restart nginx
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
                  -e MONGODB_URI=mongodb://${aws_instance.tradeflow_database_instance.private_ip}:${var.mongodb_port}/tradeflow \
                  -p ${var.microservice_1_port}:${var.microservice_1_port} \
                  ${var.microservice_1_image}

                docker run -d \
                  --name microservice-2 \
                  --restart unless-stopped \
                  -e PORT=${var.microservice_2_port} \
                  -e MONGODB_URI=mongodb://${aws_instance.tradeflow_database_instance.private_ip}:${var.mongodb_port}/tradeflow \
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
                apt install -y docker.io nginx

                systemctl start docker
                systemctl enable docker
                
                systemctl start nginx
                systemctl enable nginx

                docker run -d \
                  --name microservice-3 \
                  --restart unless-stopped \
                  -e PORT=${var.microservice_3_port} \
                  -e MONGODB_URI=mongodb://${aws_instance.tradeflow_database_instance.private_ip}:${var.mongodb_port}/tradeflow \
                  -e USER_SERVICE_URL=http"//${aws_lb.backend_alb.dns_name}/api/users \
                  -e PORTFOLIO_SERVICE_URL=http"//${aws_lb.backend_alb.dns_name}/api/portfolio \
                  -p ${var.microservice_3_port}:${var.microservice_3_port} \
                  ${var.microservice_3_image}

                docker run -d \
                  --name microservice-4 \
                  --restart unless-stopped \
                  -e PORT=${var.microservice_4_port} \
                  -e MONGODB_URI=mongodb://${aws_instance.tradeflow_database_instance.private_ip}:${var.mongodb_port}/tradeflow \
                  -p ${var.microservice_4_port}:${var.microservice_4_port} \
                  ${var.microservice_4_image}

                cat > /etc/nginx/sites-available/default <<'NGINXCONF'
                server {

                    listen 80;

                    location / {

                        proxy_pass http://localhost:3000;

                        proxy_http_version 1.1;

                        proxy_set_header Host $host;
                        proxy_set_header X-Real-IP $remote_addr;
                        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                        proxy_set_header X-Forwarded-Proto $scheme;
                    }

                    location /api/users/ {

                        proxy_pass http://${aws_lb.backend_alb.dns_name};

                        proxy_http_version 1.1;

                        proxy_set_header Host $host;
                        proxy_set_header X-Real-IP $remote_addr;
                        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                        proxy_set_header X-Forwarded-Proto $scheme;
                    }

                    location /api/stocks/ {

                        proxy_pass http://${aws_lb.backend_alb.dns_name};

                        proxy_http_version 1.1;

                        proxy_set_header Host $host;
                        proxy_set_header X-Real-IP $remote_addr;
                        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                        proxy_set_header X-Forwarded-Proto $scheme;
                    }

                    location /api/trades/ {

                        proxy_pass http://${aws_lb.backend_alb.dns_name};

                        proxy_http_version 1.1;

                        proxy_set_header Host $host;
                        proxy_set_header X-Real-IP $remote_addr;
                        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                        proxy_set_header X-Forwarded-Proto $scheme;
                    }

                    location /api/portfolio/ {

                        proxy_pass http://${aws_lb.backend_alb.dns_name};

                        proxy_http_version 1.1;

                        proxy_set_header Host $host;
                        proxy_set_header X-Real-IP $remote_addr;
                        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                        proxy_set_header X-Forwarded-Proto $scheme;
                    }
                }
                NGINXCONF

                nginx -t

                systemctl restart nginx
                EOF
    )

    tag_specifications {
        resource_type = "instance"

        tags = {
            Name = "${var.project_name}-Backend2-Instance"
        }
    }
}