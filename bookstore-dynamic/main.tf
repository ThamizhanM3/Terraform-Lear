resource "aws_lb" "bookstore_frontend_applicationloadbalancer" {
    name = "BookStoreFrontendALB"
    internal = false 
    load_balancer_type = "application"
    security_groups = [ aws_security_group.bookstore_frontend_applicationloadbalancer_securitygroup.id ]
    subnets = [ aws_subnet.bookstore_bastionhost_public_subnet_a.id, aws_subnet.bookstore_bastionhost_public_subnet_b.id ]
    tags = {
        Name = "BookkStore_Frontend_ApplicationLoadBalancer"
    }
}

resource "aws_lb_target_group" "bookstore_frontend_targetgroup" {
    name = "BookStoreFrontendTG"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.main.id
    health_check {
        path = "/"
        protocol = "HTTP"
        matcher = "200-399"
        interval = 10
        timeout = 5
        unhealthy_threshold = 5
        healthy_threshold = 2
    }
    tags = {
        Name = "BookStore_Frontend_TargetGroup"
    }
}

resource "aws_lb_target_group_attachment" "bookstore_frontend_targetgroup_attachment" {
    target_group_arn = aws_lb_target_group.bookstore_frontend_targetgroup.arn
    target_id = aws_instance.bookstore_frontend_instance.id
    port = 80
}

resource "aws_lb_listener" "bookstore_frontend_listener" {
    load_balancer_arn = aws_lb.bookstore_frontend_applicationloadbalancer.arn
    port = 80
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.bookstore_frontend_targetgroup.arn
    }
}
resource "aws_instance" "bookstore_frontend_instance" {

    ami                    = "ami-07a00cf47dbbc844c"
    instance_type          = "t2.micro"
    subnet_id              = aws_subnet.bookstore_frontend_private_subnet_a.id
    security_groups        = [aws_security_group.bookstore_frontend_securitygroup.id]
    key_name               = "M3"

    user_data = <<-EOF
                #!/bin/bash

                apt update -y

                apt install -y docker.io nginx

                systemctl start docker
                systemctl enable docker

                systemctl start nginx
                systemctl enable nginx

                docker run -d \
                    --name bookstore-frontend \
                    -p 3000:80 \
                    -e VITE_APP_API_URL="/api" \
                    thamizhanm3/book-store-frontend:latest

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

                    location /api/ {

                        proxy_pass http://${aws_lb.bookstore_backend_applicationloadbalancer.dns_name}/;

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

    tags = {
        Name = "BookStore_Frontend_Instance"
    }
}

resource "aws_instance" "bookstore_bastionhost_instance" {
    ami = "ami-07a00cf47dbbc844c"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.bookstore_bastionhost_public_subnet_a.id
    security_groups = [ aws_security_group.bookstore_bastionhost_securitygroup.id ]
    associate_public_ip_address = true 
    key_name = "M3"
    tags = {
        Name = "BookStore_BastionHost_Instance"
    }
}

resource "aws_lb" "bookstore_backend_applicationloadbalancer" {
    name = "BookStoreBackendALB"
    internal = true
    load_balancer_type = "application"
    security_groups = [ aws_security_group.bookstore_backend_applicationloadbalancer_securitygroup.id ]
    subnets = [ aws_subnet.bookstore_backend_private_subnet_a.id, aws_subnet.bookstore_backend_private_subnet_b.id ]
    tags = {
        Name = "BookkStore_Backend_ApplicationLoadBalancer"
    }
}

resource "aws_lb_target_group" "bookstore_backend_targetgroup" {
    name = "BookStoreBackendTG"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.main.id
    health_check {
        path = "/"
        protocol = "HTTP"
        matcher = "200-399"
        interval = 10
        timeout = 5
        unhealthy_threshold = 5
        healthy_threshold = 2
    }
    tags = {
        Name = "BookStore_Backend_TargetGroup"
    }
}

resource "aws_lb_target_group_attachment" "bookstore_backendend_targetgroup_attachment" {
    target_group_arn = aws_lb_target_group.bookstore_backend_targetgroup.arn
    target_id = aws_instance.bookstore_backend_instance.id
    port = 80
}

resource "aws_lb_listener" "bookstore_backend_listener" {
    load_balancer_arn = aws_lb.bookstore_backend_applicationloadbalancer.arn
    port = 80
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.bookstore_backend_targetgroup.arn
    }
}

resource "aws_instance" "bookstore_backend_instance" {
    ami = "ami-07a00cf47dbbc844c"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.bookstore_backend_private_subnet_a.id
    security_groups = [ aws_security_group.bookstore_backend_securitygroup.id ]
    key_name = "M3"
    user_data = <<-EOF
                #!/bin/bash

                apt update -y
                apt install -y docker.io

                systemctl start docker
                systemctl enable docker

                docker run -d \
                    --name bookstore-backend \
                    -p 80:5555 \
                    -e PORT=5555 \
                    -e MONGO_URI="mongodb://${aws_instance.bookstore_database_instance.private_ip}:27017/bookstore" \
                    thamizhanm3/book-store-backend:latest
                EOF
    tags = {
        Name = "BookStore_Backend_Instance"
    }
}

resource "aws_instance" "bookstore_database_instance" {
    ami = "ami-07a00cf47dbbc844c"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.bookstore_database_private_subnet_a.id
    security_groups = [ aws_security_group.bookstore_database_securitygroup.id ]
    key_name = "M3"
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
        Name = "BookStore_Database_Instance"
    }
}