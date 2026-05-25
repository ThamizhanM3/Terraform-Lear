project_name = "BookStore"
aws_region = "ap-south-1"
vpc_cidr = "10.0.0.0/16"
key_name = "M3"
availability_zones = [ "ap-south-1a", "ap-south-1b" ]
frontend_image = "thamizhanm3/frontend:latest"
backend_image = "thamizhanm3/backend:latest"
subnets = {
    "bastionhost" = {
        name = "bastionhost_public_subnet" 
        cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
        public = true
        subnet_type = "bastionhost"
    }
    "frontend" = {
        name = "frontend_private_subnet" 
        cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
        public = false
        subnet_type = "frontend"
    }
    "backend" = {
        name = "backend_private_subnet" 
        cidrs = ["10.0.21.0/24", "10.0.22.0/24"]
        public = false
        subnet_type = "backend"
    }
    "database" = {
        name = "database_private_subnet" 
        cidrs = ["10.0.31.0/24", "10.0.32.0/24"]
        public = false
        subnet_type = "database"
    }
}
