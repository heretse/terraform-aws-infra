resource "aws_eip_association" "eip_assoc_nat_server_instance" {
  instance_id   = var.nat_server_instance_id
  allocation_id = aws_eip.my_nat_server_eip.id

  depends_on = [
    var.nat_server_instance_id
  ]
}

resource "aws_eip_association" "eip_assoc_bastion_instance" {
  instance_id   = var.bastion_instance_id
  allocation_id = aws_eip.my_bastion_eip.id
  depends_on = [
    var.bastion_instance_id
  ]
}
