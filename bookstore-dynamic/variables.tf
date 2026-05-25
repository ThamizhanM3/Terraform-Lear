variable "project_name" {
    type = string
}

variable "vpc_cidr" {
    type = string
}

variable "availability_zones" {
    type = list(string)
}

variable "subnets" {
    type = map(object({
        name = string
        cidrs = list(string)
        public = bool
    }))
}

variable "aws_region" {
    type = string
}