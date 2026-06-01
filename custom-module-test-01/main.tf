terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 6.0"
        }
    }
}

provider "aws" {
    region = "ap-south-1"
}

module "custom_module" {
    source = "ThamizhanM3/01/modules"
    version = "v1.0.1"

    vpc_name = "M3_VPC"
    vpc_cidr = "10.15.0.0/16"
    public_subnet_name = "M3_Public_Subnet"
    public_subnet_cidr = "10.15.25.0/24"
    security_group_name = "M3_Security"
    instance_name = "M3_Instance"
    key_name = "M3"
}