resource "aws_eip" "nat_eip" {
    for_each = local.public_subnets
    domain = "vpc"
    tags = {
        Name = "${each.key}-eip"
    }
}

resource "aws_nat_gateway" "nat" {
    for_each = local.public_subnets
    allocation_id = aws_eip.nat_eip[each.key].id
    subnet_id = aws_subnet.subnets[each.key].id
    tags = {
        Name = "${each.key}-nat"
    }
    depends_on = [
        aws_internet_gateway.igw
    ]
}