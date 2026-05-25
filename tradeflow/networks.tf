resource "aws_internet_gateway" "tradeflow_igw" {
    vpc_id = aws_vpc.tradeflow_vpc.id

    tags = {
        Name = "${var.project_name}-InternetGateway"
    }
}

resource "aws_eip" "tradeflow_nat_eip" {
    domain = "vpc"

    tags = {
        Name = "${var.project_name}-NAT-EIP"
    }
}

resource "aws_nat_gateway" "tradeflow_nat_gateway" {
    allocation_id = aws_eip.tradeflow_nat_eip.id
    subnet_id     = aws_subnet.bastionhost_subnet_a.id

    depends_on = [
        aws_internet_gateway.tradeflow_igw
    ]

    tags = {
        Name = "${var.project_name}-NATGateway"
    }
}