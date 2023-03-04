output "bastion_public_ip" {
  value = aws_eip.nxd_bastion_eip.public_ip
}

output "bastion_eip_id" {
  value = aws_eip.nxd_bastion_eip.id
}

output "nat_server_public_ip" {
  value = aws_eip.nxd_nat_server_eip.public_ip
}

output "nat_server_eip_id" {
  value = aws_eip.nxd_nat_server_eip.id
}

output "nat_server_eip_assoc_eni_id" {
  value = aws_eip.nxd_nat_server_eip.network_interface
}
