output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.ec2.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.ec2.associate_public_ip_address
}
output "instance_ip_addr" {
  value = aws_instance.ec2.associate_public_ip_address
}
output "public-ip" {
 value = aws_instance.ec2.public_ip 
}

output "ssh-command" {
  value = "ssh -i ${local_file.priv_key.filename}  ec2-user@${aws_instance.ec2.public_ip}"
}