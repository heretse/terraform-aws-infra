data "local_file" "configure_nat" {
  filename = "${path.module}/configure_nat.sh"
}

resource "aws_instance" "my_bastion_instance" {
  # checkov:skip=CKV2_AWS_41: need to add iam role later
  ami                    = (var.ami_id != null) ? var.ami_id : data.aws_ami.ami.id
  instance_type          = var.instance_type
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [var.bastion_security_group_id]
  subnet_id              = var.subnet_bastion_id

  tags = {
    Department = var.department_name
    Project    = var.project_name
    Name       = "Bastion"
  }
}

resource "aws_instance" "my_nat_server_instance" {
  # checkov:skip=CKV2_AWS_41: need to add iam role later
  ami                    = (var.ami_id != null) ? var.ami_id : data.aws_ami.ami.id
  instance_type          = var.instance_type
  key_name               = var.ssh_key_name
  vpc_security_group_ids = [var.nat_server_security_group_id]
  source_dest_check      = false
  subnet_id              = var.subnet_nat_server_id
  user_data_base64       = data.local_file.configure_nat.content_base64

  tags = {
    Department = var.department_name
    Project    = var.project_name
    Name       = "NAT Server"
  }
}
