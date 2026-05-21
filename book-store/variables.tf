variable "aws_region" {
    type = string
}

variable "availability_zone_a" {
    type = string
}

variable "availability_zone_b" {
    type = string
}

variable "bookstore_vpc_cidr" {
    type = string
}

variable "bookstore_bastionhost_public_subnet_a_cidr" {
    type = string
}

variable "bookstore_bastionhost_public_subnet_b_cidr" {
    type = string
}

variable "bookstore_frontend_private_subnet_a_cidr" {
    type = string
}

variable "bookstore_frontend_private_subnet_b_cidr" {
    type = string
}

variable "bookstore_backend_private_subnet_a_cidr" {
    type = string
}

variable "bookstore_backend_private_subnet_b_cidr" {
    type = string
}

variable "bookstore_database_private_subnet_a_cidr" {
    type = string
}

variable "bookstore_database_private_subnet_b_cidr" {
    type = string
}