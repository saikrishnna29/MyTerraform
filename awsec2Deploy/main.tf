provider "aws" {
    region = "ap-south-1"
}

resource "aws_vpc" "vpc-example" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    tags = {
      Name = "terraform-vpc"
    }
}

resource "aws_subnet" "subnet-example" {
    vpc_id = aws_vpc.vpc-example.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = true
    tags = {
      Name = "terraform-subnet"
    }
}

resource "aws_internet_gateway" "igw-example" {
    vpc_id = aws_vpc.vpc-example.id
    tags = {
      Name = "terraform-igw"
    }
}

resource "aws_route_table_association" "rta-example" {
    subnet_id = aws_subnet.subnet-example.id
    route_table_id = aws_vpc.vpc-example.main_route_table_id
}

resource "aws_route" "route-example" {
    route_table_id = aws_vpc.vpc-example.main_route_table_id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-example.id
}

resource "aws_security_group" "terraform-sg" {
    vpc_id = aws_vpc.vpc-example.id
    name = "terraform-security-group"
    tags = {
      Name = "terraform-sg"
    }
}

resource "aws_security_group_rule" "ssh_in" {
    security_group_id = aws_security_group.terraform-sg.id
    protocol = "tcp"
    from_port = 22
    to_port = 22
    type = "ingress"
    cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_instance" "instance-example" {
    ami = "ami-04893cdb768d0f9ee"
    associate_public_ip_address = true
    availability_zone = "ap-south-1a"
    instance_type = "t2.micro"
    key_name = "AWSDevops"
    vpc_security_group_ids = ["sg-0ddd676c60802bdcb"]
    subnet_id = aws_subnet.subnet-example.id
    tags = {
      Name = "instance-example"
    }
}


output "vpc_id" {
    value = aws_vpc.vpc-example.id
}

output "subnet_id" {
    value = aws_subnet.subnet-example.id
}

output "security_group_id" {
    value = aws_security_group.terraform-sg.id
}

output "security-group-rule_id" {
    value = aws_security_group_rule.ssh_in.id
}

output "aws_route_table_association_id" {
    value = aws_route_table_association.rta-example.route_table_id
}

output "aws_route_id" {
    value = aws_route.route-example.id
}

output "instance_id" {
    value = aws_instance.instance-example.id
}
