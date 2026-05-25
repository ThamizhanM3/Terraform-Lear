resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true 
    enable_dns_support = true 
    tags = {
        Name = "TradeFlow_VPC"
    }
}

resource "aws_subnet" "bastionhost_subnet_a" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.bastionhost_subnet_a_cidr
    availability_zone = var.availability_zone_a
    map_public_ip_on_launch = true
    tags = {
        Name = "TradeFlow_BastionHost_Subnet_A"
    }
}

resource "aws_subnet" "bastionhost_subnet_b" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.bastionhost_subnet_b_cidr
    availability_zone = var.availability_zone_b
    map_public_ip_on_launch = true
    tags = {
        Name = "TradeFlow_BastionHost_Subnet_B"
    }
}

resource "aws_subnet" "frontend_subnet_a" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.frontend_subnet_a_cidr
    availability_zone = var.availability_zone_a
    tags = {
        Name = "TradeFlow_Frontend_Subnet_A"
    }
}

resource "aws_subnet" "frontend_subnet_b" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.frontend_subnet_b_cidr
    availability_zone = var.availability_zone_b
    tags = {
        Name = "TradeFlow_Frontend_Subnet_B"
    }
}

resource "aws_subnet" "backend_subnet_a" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.backend_subnet_a_cidr
    availability_zone = var.availability_zone_a
    tags = {
        Name = "TradeFlow_Backend_Subnet_A"
    }
}

resource "aws_subnet" "backend_subnet_b" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.backend_subnet_b_cidr
    availability_zone = var.availability_zone_b
    tags = {
        Name = "TradeFlow_BackendSubnet_B"
    }
}

resource "aws_subnet" "database_subnet_a" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.database_subnet_a_cidr
    availability_zone = var.availability_zone_a
    tags = {
        Name = "TradeFlow_Database_Subnet_A"
    }
}

resource "aws_subnet" "database_subnet_b" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.database_subnet_b_cidr
    availability_zone = var.availability_zone_b
    tags = {
        Name = "TradeFlow_Database_Subnet_B"
    }
}

resource "aws_internet_gateway" "internetgateway" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "TradeFlow_InternetGateway"
    }
}

resource "aws_route_table" "public_routetable" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internetgateway.id
    }
    tags = {
        Name = "TradeFlow_Public_RouteTable"
    }
}

resource "aws_route_table_association" "bastionhost_subnet_a_association" {
    subnet_id = aws_subnet.bastionhost_subnet_a.id
    route_table_id = aws_route_table.public_routetable.id
}

resource "aws_route_table_association" "bastionhost_subnet_b_association" {
    subnet_id = aws_subnet.bastionhost_subnet_b.id
    route_table_id = aws_route_table.public_routetable.id
}

resource "aws_eip" "natgateway_eip" {
    domain = "vpc"
    tags = {
        Name = "TradeFlow_NATGateway_ElasticIP"
    }
}

resource "aws_nat_gateway" "natgateway" {
    allocation_id = aws_eip.natgateway_eip.id
    subnet_id = aws_subnet.bastionhost_subnet_a.id
    tags = {
        Name = "TradeFlow_NATGateway"
    }
    depends_on = [ aws_internet_gateway.internetgateway ]
}

resource "aws_route_table" "frontend_routetable" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.natgateway.id
    }
    tags = {
        Name = "TradeFlow_Frontend_Private_RouteTable"
    }
}

resource "aws_route_table_association" "frontend_subnet_a_association" {
    subnet_id = aws_subnet.frontend_subnet_a.id
    route_table_id = aws_route_table.frontend_routetable.id
}

resource "aws_route_table_association" "frontend_subnet_b_association" {
    subnet_id = aws_subnet.frontend_subnet_b.id
    route_table_id = aws_route_table.frontend_routetable.id
}

resource "aws_route_table" "backend_routetable" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.natgateway.id
    }
    tags = {
        Name = "TradeFlow_Backend_Private_RouteTable"
    }
}

resource "aws_route_table_association" "backend_subnet_a_association" {
    subnet_id = aws_subnet.backend_subnet_a.id
    route_table_id = aws_route_table.backend_routetable.id
}

resource "aws_route_table_association" "backend_subnet_b_association" {
    subnet_id = aws_subnet.backend_subnet_b.id
    route_table_id = aws_route_table.backend_routetable.id
}

resource "aws_route_table" "database_routetable" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.natgateway.id 
    }
}

resource "aws_route_table_association" "database_subnet_a_association" {
    subnet_id = aws_subnet.database_subnet_a.id 
    route_table_id = aws_route_table.database_routetable.id
}

resource "aws_route_table_association" "database_subnet_b_association" {
    subnet_id = aws_subnet.database_subnet_b.id
    route_table_id = aws_route_table.database_routetable.id
}

resource "aws_security_group" "bastionhost_securitygroup" {
    name = "TradeFlow_BH_SG"
    description = "TradeFlow_BH_SG"
    vpc_id = aws_vpc.vpc.id
    ingress {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "frontend_applicationloadbalancer_securitygroup" {
    name = "TradeFlow_Frontend_ALB_SG"
    description = "TradeFlow_Frontend_ALB_SG"
    vpc_id = aws_vpc.vpc.id
    ingress {
        description = "HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "frontend_securitygroup" {
    name = "TradeFlow_Frontend_SG"
    description = "TradeFlow_Frontend_SG"
    vpc_id = aws_vpc.vpc.id
    ingress {
        description = "HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [aws_security_group.frontend_applicationloadbalancer_securitygroup.id]
    }
    ingress {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = [aws_security_group.bastionhost_securitygroup.id]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "backend_applicationloadbalancer_securitygroup" {
    name = "TradeFlow_Backend_ALB_SG"
    description = "TradeFlow_Backend_ALB_SG"
    vpc_id = aws_vpc.vpc.id
    ingress {
        description = "HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [ aws_security_group.frontend_securitygroup.id ]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "backend_securitygroup" {
    name = "TradeFlow_Backend_SG"
    description = "TradeFlow_Backend_SG"
    vpc_id = aws_vpc.vpc.id
    ingress {
        description = "HTTP"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [aws_security_group.backend_applicationloadbalancer_securitygroup.id]
    }
    ingress {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = [ aws_security_group.bastionhost_securitygroup.id ]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "database_securitygroup" {
    name = "TradeFlow_Database_SG"
    description = "TradeFlow_Database_SG"
    vpc_id = aws_vpc.vpc.id
    ingress {
        description = "HTTP"
        from_port = 27017
        to_port = 27017
        protocol = "tcp"
        security_groups = [ aws_security_group.backend_securitygroup.id ]
    }
    ingress {
        description = "SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = [ aws_security_group.bastionhost_securitygroup.id ]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_lb" "frontend_applicationloadbalancer" {
    name = "TradeFlowFrontendALB"
    internal = false 
    load_balancer_type = "application"
    security_groups = [ aws_security_group.frontend_applicationloadbalancer_securitygroup.id ]
    subnets = [ aws_subnet.bastionhost_subnet_a.id, aws_subnet.bastionhost_subnet_b.id ]
    tags = {
        Name = "BookkStore_Frontend_ApplicationLoadBalancer"
    }
}

resource "aws_lb_target_group" "frontend_targetgroup" {
    name = "TradeFlowFrontendTG"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.vpc.id
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
        Name = "TradeFlow_Frontend_TargetGroup"
    }
}

resource "aws_lb_target_group_attachment" "frontend_targetgroup_attachment" {
    target_group_arn = aws_lb_target_group.frontend_targetgroup.arn
    target_id = aws_instance.frontend_instance.id
    port = 80
}

resource "aws_lb_listener" "frontend_listener" {
    load_balancer_arn = aws_lb.frontend_applicationloadbalancer.arn
    port = 80
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.frontend_targetgroup.arn
    }
}
resource "aws_instance" "frontend_instance" {

    ami                    = "ami-07a00cf47dbbc844c"
    instance_type          = "t2.micro"
    subnet_id              = aws_subnet.frontend_subnet_a.id
    security_groups        = [aws_security_group.frontend_securitygroup.id]
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

                      proxy_pass http://${aws_lb.backend_applicationloadbalancer.dns_name}/;

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
        Name = "TradeFlow_Frontend_Instance"
    }
}

resource "aws_instance" "bastionhost_instance" {
    ami = "ami-07a00cf47dbbc844c"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.bastionhost_subnet_a.id
    security_groups = [ aws_security_group.bastionhost_securitygroup.id ]
    associate_ip_address = true 
    key_name = "M3"
    tags = {
        Name = "TradeFlow_BastionHost_Instance"
    }
}

resource "aws_lb" "backend_applicationloadbalancer" {
    name = "TradeFlowBackendALB"
    internal = true
    load_balancer_type = "application"
    security_groups = [ aws_security_group.backend_applicationloadbalancer_securitygroup.id ]
    subnets = [ aws_subnet.backend_subnet_a.id, aws_subnet.backend_subnet_b.id ]
    tags = {
        Name = "BookkStore_Backend_ApplicationLoadBalancer"
    }
}

resource "aws_lb_target_group" "backend_targetgroup" {
    name = "TradeFlowBackendTG"
    port = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.vpc.id
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
        Name = "TradeFlow_Backend_TargetGroup"
    }
}

resource "aws_lb_target_group_attachment" "backendend_targetgroup_attachment" {
    target_group_arn = aws_lb_target_group.backend_targetgroup.arn
    target_id = aws_instance.backend_instance.id
    port = 80
}

resource "aws_lb_listener" "backend_listener" {
    load_balancer_arn = aws_lb.backend_applicationloadbalancer.arn
    port = 80
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.backend_targetgroup.arn
    }
}

resource "aws_instance" "backend_instance" {
    ami = "ami-07a00cf47dbbc844c"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.backend_subnet_a.id
    security_groups = [ aws_security_group.backend_securitygroup.id ]
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
                -e MONGO_URI="mongodb://${aws_instance.database_instance.private_ip}:27017/bookstore" \
                thamizhanm3/book-store-backend:latest
              EOF
    tags = {
        Name = "TradeFlow_Backend_Instance"
    }
}

resource "aws_instance" "database_instance" {
    ami = "ami-07a00cf47dbbc844c"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.database_subnet_a.id
    security_groups = [ aws_security_group.database_securitygroup.id ]
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
        Name = "TradeFlow_Database_Instance"
    }
}