resource "aws_vpc" "vpc_oneninetytwo" {
    cidr_block = "192.0.0.0/16"
    enable_dns_hostnames = true
    tags = {
        Name = "${var.vpc_name}${var.vpc_suffix}"
    }
}
