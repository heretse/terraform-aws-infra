output "bastion_instance_id" {
  value = aws_instance.bastion_instance.id
}

output "nat_server_instance_id" {
  value = aws_instance.nat_server_instance.id
}
