
output "vpc" {
    value = aws_vpc.create_vpc
}


output "subnet1" {
    value = aws_subnet.create_subnet1
}

output "subnet2" {
    value = aws_subnet.create_subnet2
}
