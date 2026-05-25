resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
        Name = "public-rt"
    }
}

resource "aws_route_table_association" "public_assoc" {
    for_each = local.public_subnets
    subnet_id = aws_subnet.subnets[each.key].id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
    for_each = local.private_subnets
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat["bastion-${substr(each.key, -1, 1)}"].id
    }
    tags = {
        Name = "${each.key}-rt"
    }
}

resource "aws_route_table_association" "private_assoc" {
    for_each = local.private_subnets
    subnet_id = aws_subnet.subnets[each.key].id
    route_table_id = aws_route_table.private[each.key].id
}