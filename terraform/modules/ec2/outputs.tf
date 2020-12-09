output "public_ip" {
  description = "Public IP of the instance"
  value       = aws_instance.instance.public_ip
}