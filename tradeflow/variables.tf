variable "aws_region" {
    type = string
}

variable "availability_zone_a" {
    type = string
}

variable "availability_zone_b" {
    type = string
}

variable "project_name" {
    type = string
}

variable "vpc_cidr" {
    type = string
}

variable "bastionhost_subnet_a_cidr" {
    type = string
}

variable "bastionhost_subnet_b_cidr" {
    type = string
}

variable "frontend_subnet_a_cidr" {
    type = string
}

variable "frontend_subnet_b_cidr" {
    type = string
}

variable "backend_subnet_a_cidr" {
    type = string
}

variable "backend_subnet_b_cidr" {
    type = string
}

variable "database_subnet_a_cidr" {
    type = string
}

variable "database_subnet_b_cidr" {
    type = string
}

variable "instance_type" {
    type = string
}

variable "ami_id" {
    type = string
}

variable "key_name" {
    type = string
}

variable "desired_capacity" {
    type = number
}

variable "min_size" {
    type = number
}

variable "max_size" {
    type = number
}

variable "frontend_docker_image" {
    type = string
}

variable "microservice_1_image" {
    type = string
}

variable "microservice_2_image" {
    type = string
}

variable "microservice_3_image" {
    type = string
}

variable "microservice_4_image" {
    type = string
}

variable "mongodb_image" {
    type = string
}

variable "frontend_port" {
    type = number
}

variable "microservice_1_port" {
    type = number
}

variable "microservice_2_port" {
    type = number
}

variable "microservice_3_port" {
    type = number
}

variable "microservice_4_port" {
    type = number
}

variable "mongodb_port" {
    type = number
}