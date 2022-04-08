

provider "aws" {
    region = "ap-south-1"
}

resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    tags = {
        Name = "nginx-vpc"
    }
}

resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "nginx-igw"
    }
}

resource "aws_subnet" "public" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = aws_vpc.vpc.cidr_block
    map_public_ip_on_launch = true
    availability_zone = "ap-south-1a"
    tags = {
        Name = "nginx-subnet"
    }
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }
    tags = {
        Name = "nginx-rt-public"
    }
}

resource "aws_route_table_association" "gateway_route" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "rules" {
    name = "example"
    vpc_id = aws_vpc.vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.my_ip}/32"] #public-ip of the ec2-instance where this code runs which must be defined in variable.tf and terraform.tfvars
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "nginx-sg"
    }
}

#make sure to create a key-pair using ssh-keygen in the project directory 
resource "aws_key_pair" "keypair" {
    key_name = "key"
    public_key = file("<key-name>.pub")
}

data "aws_ami" "ami" {
    most_recent = true
    owners = ["amazon"]

    filter {
        name = "name"
        values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
    }
}

resource "aws_instance" "nginx" {
    ami = data.aws_ami.ami.image_id
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public.id
    vpc_security_group_ids = [aws_security_group.rules.id]
    key_name = aws_key_pair.keypair.key_name
    tags = {
        Name = "nginx-webserver"
    }


    provisioner "remote-exec" {
        inline = [
            "sudo amazon-linux-extras enable nginx1.12",
            "sudo yum -y install nginx",
            "sudo chmod 777 /usr/share/nginx/html/index.html",
            "echo \"Hello from nginx on AWS\" > /usr/share/nginx/html/index.html",
            "sudo systemctl start nginx",
        ]
    }

    connection {
        host = aws_instance.nginx.public_ip
        type = "ssh"
        user = "ec2-user"
        private_key = file("<key-name-without-.pub-extension")
    }
}
