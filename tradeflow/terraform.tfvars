aws_region = "ap-south-1"

availability_zone_a = "ap-south-1a"
availability_zone_b = "ap-south-1b"

vpc_cidr = "10.0.0.0/16"

bastionhost_subnet_a_cidr = "10.0.1.0/24"
bastionhost_subnet_b_cidr = "10.0.2.0/24"
frontend_subnet_a_cidr = "10.0.11.0/24"
frontend_subnet_b_cidr = "10.0.12.0/24"
backend_subnet_a_cidr = "10.0.21.0/24"
backend_subnet_b_cidr = "10.0.22.0/24"
database_subnet_a_cidr = "10.0.31.0/24"
database_subnet_b_cidr = "10.0.32.0/24"

instance_type = "t2.micro"
ami_id = "ami-07a00cf47dbbc844c"
key_name = "M3"

desired_capacity = 2
min_size = 1
max_size = 3

frontend_docker_image = "thamizhanm3/tradefloe-frontend:latest"
microservice_1_image = "thamizhanm3/tradeflow-user:latest"
microservice_2_image = "thamizhanm3/tradeflow-stock:latest"
microservice_3_image = "thamizhanm3/tradeflow-trading:latest"
microservice_4_image = "thamizhanm3/tradeflow-portfolio:latest"
mongodb_image = "mongo:latest"

frontend_port = 80
microservice_1_port = 4001
microservice_2_port = 4002
microservice_3_port = 4003
microservice_4_port = 4004
mongodb_port = 27017