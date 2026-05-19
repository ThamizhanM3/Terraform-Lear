terraform {
  required_providers {
    aws = {
      source  = "registry.terraform.io/hashicorp/aws"
      version = "6.44.0"
    }
  }
}

provider "aws" {
    region = var.aws_region
}

resource "aws_instance" "M3_004" {
    ami = var.ami_id
    instance_type = var.instance_type
}