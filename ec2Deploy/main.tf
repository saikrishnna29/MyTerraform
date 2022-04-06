
provider "aws" {
    region = "ap-south-1"
}

resource "aws_vpc" "vpc_create" {
    cidr_block = "192.0.0.0/16"
    enable_dns_hostnames = true
    tags = {
        Name = "vpc-tf"
    }
}

resource "aws_internet_gateway" "igw_create" {
    vpc_id = aws_vpc.vpc_create.id
    tags = {
        Name = "igw-tf"
    }
}

resource "aws_subnet" "subnet_create" {
    vpc_id = aws_vpc.vpc_create.id
    cidr_block = "192.0.1.0/24"
    availability_zone = "ap-south-1a"
    map_public_ip_on_launch = true
    tags = {
        Name = "subnet-tf"
    }
}

resource "aws_route_table" "rt_create" {
    vpc_id = aws_vpc.vpc_create.id
    route {
      cidr_block = "192.0.1.0/24"
      gateway_id = aws_internet_gateway.igw_create.id
    }
    tags = {
        Name = "rt-tf"
    }
}

resource "aws_route_table_association" "rta-subnet" {
    subnet_id = aws_subnet.subnet_create.id
    route_table_id = aws_route_table.rt_create.id
}

resource "aws_security_group" "sg_create" {
    vpc_id = aws_vpc.vpc_create.id
    ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
}
    tags = {
        Name = "security-group-tf"
    }
}

resource "aws_instance" "instance_tf" {
    ami = "ami-04893cdb768d0f9ee"
    instance_type = "t2.micro"
    key_name = "AWSDevops"  
    subnet_id = aws_subnet.subnet_create.id
    tags = {
        Name = "ec2-tf"
    }
}

output "vpc_info" {
    value = "vpc-id: ${aws_vpc.vpc_create.id}"
}

output "subnet_info" {
    value = "subnet-id: ${aws_subnet.subnet_create.id}"
}

output "securitygroup_info" {
    value = "sg-id: ${aws_security_group.sg_create.id}"
}

output "ec2_info" {
    value = "instance-id: ${aws_instance.instance_tf.id}"
}
