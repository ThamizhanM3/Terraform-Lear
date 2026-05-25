variable "project_name" {
    type = string
}

variable "aws_region" {
    type = string
}

variable "vpc_cidr" {
    type = string
}

variable "availability_zones" {
    type = list(string)
}

variable "key_name" {
    type = string
}

variable "frontend_image" {
    type = string
}

variable "backend_image" {
    type = string
}

variable "subnets" {
    type = map(object({
        name = string
        cidrs = list(string)
        public = bool
    }))
}
