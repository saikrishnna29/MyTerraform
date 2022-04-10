

output "vpc_id" {
    value = aws_vpc.test_vpc.id
}

output "subnet_id" {
    value = aws_subnet.public.id
}

output "igw_id" {
    value = aws_internet_gateway.main.id
}

output "instance_id" {
    value = aws_instance.jenkins.id
}
