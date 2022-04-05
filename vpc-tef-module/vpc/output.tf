
output "vpc_info" {
value = "vpc-id: {aws_vpc.vpc_name.id}, vpc-name: {var.vpc_name}"
}
