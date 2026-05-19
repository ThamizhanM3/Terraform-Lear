provider "aws" {
    region = "ap-south-1"
}

resource "aws_instance" "M3_001" {
    ami = "ami-07a00cf47dbbc844c"
    instance_type = "t2.micro"

    tags = {
        Name = "M3_001Tag"
    }
}