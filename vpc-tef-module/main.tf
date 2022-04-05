provider "aws" {
  region = "ap-south-1"
}

module "vpc_create" {
    source = "./vpc"
    vpc_name = "from-module"
}

module "vpc_another" {
    source = "./vpc"
    vpc_name = "another-module"
}

output "module_data" {
    value = module.vpc_name.vpc_info
}
