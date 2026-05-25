project_name = "BookStore"

vpc_cidr = "10.0.0.0/16"

availability_zones = [ "ap-south-1a", "ap-south-1b" ]

subnets = {
    "bastionhost" = {
        name = "bastionhost_public_subnet" 
        cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
        public = true
    }
    "frontend" = {
        name = "frontend_private_subnet" 
        cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
        public = false
    }
    "backend" = {
        name = "backend_private_subnet" 
        cidrs = ["10.0.21.0/24", "10.0.22.0/24"]
        public = false
    }
    "database" = {
        name = "database_private_subnet" 
        cidrs = ["10.0.31.0/24", "10.0.32.0/24"]
        public = false
    }
}

aws_region = "ap-south-1"