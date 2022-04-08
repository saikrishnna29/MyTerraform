
provider "aws" {
    region = "ap-south-1"
}

module "vpc" {
    source = "./vpc"
    vpc_name = "from-module-vpc"
    vpc_cidr = "192.0.0.0/16"
    subnet_1 = "192.0.6.0/24"
    subnet_2 = "192.0.14.0/24"
}

output "vpc" {
    value = module.vpc
}
