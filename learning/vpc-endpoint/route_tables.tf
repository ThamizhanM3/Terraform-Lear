resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "${var.project_name}-Public-RouteTable"
    }
}

resource "aws_route_table_association" "public_subnet_association" {
    subnet_id      = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_route_table" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat_gateway.id
    }

    tags = {
        Name = "${var.project_name}-Private-RouteTable"
    }
}

resource "aws_route_table_association" "private_subnet_association" {
    subnet_id      = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.private_route_table.id
}


resource "aws_vpc_endpoint" "s3_endpoint" {
    vpc_id            = aws_vpc.main.id
    service_name      = "com.amazonaws.${var.aws_region}.s3"
    vpc_endpoint_type = "Gateway"

    route_table_ids = [
        aws_route_table.private_route_table.id
    ]

    tags = {
        Name = "${var.project_name}-S3-Endpoint"
    }
}
