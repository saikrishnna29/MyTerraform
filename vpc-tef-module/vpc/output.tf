output "vpc_info" {
    value = "vpc-id: ${aws_vpc.vpc_oneninetytwo.id}, vpc_name: ${var.vpc_name}${var.vpc_suffix}"
}
