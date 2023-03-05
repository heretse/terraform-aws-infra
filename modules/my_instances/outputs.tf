output "my_bastion_instance_id" {
  value = aws_instance.my_bastion_instance.id
}

output "my_nat_server_instance_id" {
  value = aws_instance.my_nat_server_instance.id
}
