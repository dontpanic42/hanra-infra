output "public_subnets" {
  value       = [aws_subnet.hanra_public_subnet_1.id]
  description = "All public subnets currently defined"
}

output "vpc_id" {
  value       = aws_vpc.hanra_vpc.id
  description = "Id of the vpc that the app is running in"
}