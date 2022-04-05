
provider "aws" {
  region = "ap-south-1"
}


module "vpc" {
  source = "./vpc"
  vpc_name = "module-vpc"
}

module "a" {
  source = "./vpc"
  vpc_name = "from-module-vpc"
}

output "vpc" {
  value = module.vpc.vpc_info
}
