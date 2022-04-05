
resource "aws_vpc" "vpc_oneseventwoseries" {
cidr_block = "172.0.0.0/16"
tags = {
Name = var.vpc_name
}
}

