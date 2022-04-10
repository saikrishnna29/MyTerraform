
provider "aws" {
    region = "ap-south-1"
}

module "jenkinsModule" {
    source = "./jenkins"
    instance = "t2.micro"
    vpc_name = "JenkinsVpc"
    subnet_name = "JenkinsPublicSubnet"
    igw_name = "JenkinsIgw"
    my_ip = "13.233.160.69" #public-ip of host instance
}

output "jenkins_info" {
    value = module.jenkinsModule
}
