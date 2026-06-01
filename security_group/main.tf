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

resource "aws_security_group" "test_1" {
    name = "test_sg_01"
    description = "test_sg_01"
    vpc_id = "vpc-042b607a52309517d"
    tags = {
        Name = "test_01_sg"
    }
}

resource "aws_security_group" "test_2" {
    name = "test_sg_02"
    description = "test_sg_02"
    vpc_id = "vpc-042b607a52309517d"
    tags = {
        Name = "test_02_sg"
    }
}

resource "aws_vpc_security_group_ingress_rule" "ingress_self_1" {
    security_group_id = aws_security_group.test_1.id

    from_port = 80
    to_port = 80
    ip_protocol = "tcp"
    referenced_security_group_id = aws_security_group.test_2.id
}

resource "aws_vpc_security_group_egress_rule" "egress_1" {
    security_group_id = aws_security_group.test_1.id

    from_port   = 0
    to_port     = 0
    ip_protocol    = "-1"
    cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_self_2" {
    security_group_id = aws_security_group.test_2.id

    from_port = 80
    to_port = 80
    ip_protocol = "tcp"
    referenced_security_group_id = aws_security_group.test_1.id
}

resource "aws_vpc_security_group_egress_rule" "egress_2" {
    security_group_id = aws_security_group.test_2.id

    from_port   = 0
    to_port     = 0
    ip_protocol    = "-1"
    cidr_ipv4 = "0.0.0.0/0"
}