resource "aws_internet_gateway" "bookstore_internetgateway" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "${var.project_name}-igw"
    }
}