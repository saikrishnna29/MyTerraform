
resource "aws_vpc" "test_vpc" {
    cidr_block = "192.0.0.0/16"
    enable_dns_hostnames = true
    tags = {
        Name = var.vpc_name #vpc variable
    }
} 

resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.test_vpc.id
    tags = {
        Name = var.igw_name #igw variable
    }
}

resource "aws_subnet" "public" {
    vpc_id = aws_vpc.test_vpc.id
    cidr_block = "192.0.4.0/24"
    map_public_ip_on_launch = true
    availability_zone = "ap-south-1a"
    tags = {
        Name = var.subnet_name #subnet variable 
    }
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.test_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }

    tags = {
        Name = "test-public-rt"
    }
}

resource "aws_route_table_association" "public_route" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "rules" {
    name = "jenkins-sg"
    vpc_id = aws_vpc.test_vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.my_ip}/32"] #ip address variable
    }

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port =0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "jenkins-security-group"
    }
}

resource "aws_key_pair" "keypair" {
    key_name = "MyTestKey"
    public_key = file("jenkins_key.pub") #generate key using ssh-keygen in the project directory
}

data "aws_ami" "ami" {
    most_recent = true
    owners = ["amazon"]

    filter {
        name = "name"
        values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
    }
}

resource "aws_instance" "jenkins" {
    ami = data.aws_ami.ami.image_id
    associate_public_ip_address = true
    instance_type = var.instance #instance variable
    subnet_id = aws_subnet.public.id
    key_name = aws_key_pair.keypair.key_name
    vpc_security_group_ids = [aws_security_group.rules.id]
    tags = {
        Name = "JenkinsTestServer"
    }

    user_data = <<EOF
    #!/bin/bash
    yum update -y
    yum install -y docker && systemctl start docker && systemctl enable docker
    EOF

    connection {
        host = aws_instance.jenkins.public_ip
        type = ssh
        user = "ec2-user"
        private_key = file("jenkins_key")
    }
}

