output "instance_ip" {
  description = "Public IP Address of the EC2 instance."
  value       = aws_instance.app_server[0].public_ip
}
