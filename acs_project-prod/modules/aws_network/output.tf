
#public subnets
output "public_subnet" {
  value = aws_subnet.public_subnet[*].id
}

#private subnets
output "private_subnet" {
  value = aws_subnet.private_subnet[*].id
}

#vpc output
output "vpc" {
  value = aws_vpc.group13-vpc.id
}