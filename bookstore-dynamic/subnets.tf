resource "aws_subnet" "subnets" {
    for_each = local.subnet_map
    vpc_id = aws_vpc.main.id
    cidr_block = each.value.cidr_block
    availability_zone = each.value.availability_zone
    map_public_ip_on_launch = each.value.public
    tags = {
        Name = "${var.project_name}-${each.value.subnet_name}-${each.value.index}"
        Type = each.value.subnet_type
    }
}