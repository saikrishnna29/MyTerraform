
resource "aws_vpc" "create_vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    tags = {
        Name = var.vpc_name
    }
}

resource "aws_subnet" "create_subnet1" {
    cidr_block = var.subnet_1
    vpc_id = aws_vpc.create_vpc.id
    tags = {
        Name = "subnet1"
    }
}

resource "aws_subnet" "create_subnet2" {
    cidr_block = var.subnet_2
    vpc_id = aws_vpc.create_vpc.id
    tags = {
        Name = "subnet2"
    }
}
