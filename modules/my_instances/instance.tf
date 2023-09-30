data "local_file" "configure_nat" {
  filename = "${path.module}/configure_nat.sh"
}

resource "aws_instance" "bastion_instance" {
  # checkov:skip=CKV2_AWS_41: need to add iam role later
  # checkov:skip=CKV_AWS_79: "Ensure Instance Metadata Service Version 1 is not enabled"
  # checkov:skip=CKV_AWS_126: "Ensure that detailed monitoring is enabled for EC2 instances"
  # checkov:skip=CKV_AWS_135: "Ensure that EC2 is EBS optimized"
  # checkov:skip=CKV_AWS_8: "Ensure all data stored in the Launch configuration or instance Elastic Blocks Store is securely encrypted"

  ami                    = (var.bastion_ami_id != null) ? var.bastion_ami_id : data.aws_ami.bastion_ami.id
  instance_type          = var.instance_type
  key_name               = var.ssh_key_name
  vpc_security_group_ids = var.bastion_security_group_ids
  subnet_id              = var.subnet_bastion_id
  user_data              = var.bastion_user_data

  dynamic "launch_template" {
    for_each = (var.bastion_launch_template != null) ? [var.bastion_launch_template] : []
    content {
      name    = launch_template.value.name
      version = launch_template.value.version
    }
  }

  tags = {
    Department           = var.department_name
    Project              = var.project_name
    Name                 = "Bastion"
    "Prometheus-monitor" = "enabled"
  }
}

resource "aws_instance" "nat_server_instance" {
  # checkov:skip=CKV2_AWS_41: need to add iam role later
  # checkov:skip=CKV_AWS_79: "Ensure Instance Metadata Service Version 1 is not enabled"
  # checkov:skip=CKV_AWS_126: "Ensure that detailed monitoring is enabled for EC2 instances"
  # checkov:skip=CKV_AWS_135: "Ensure that EC2 is EBS optimized"
  # checkov:skip=CKV_AWS_8: "Ensure all data stored in the Launch configuration or instance Elastic Blocks Store is securely encrypted"

  count = var.create_nat_server_instance ? 1 : 0

  ami                    = (var.nat_server_ami_id != null) ? var.nat_server_ami_id : data.aws_ami.ami.id
  instance_type          = var.instance_type
  key_name               = var.ssh_key_name
  vpc_security_group_ids = var.nat_server_security_group_ids
  source_dest_check      = false
  subnet_id              = var.subnet_nat_server_id
  user_data_base64       = data.local_file.configure_nat.content_base64

  dynamic "launch_template" {
    for_each = (var.nat_server_launch_template != null) ? [var.nat_server_launch_template] : []
    content {
      name    = launch_template.value.name
      version = launch_template.value.version
    }
  }
  tags = {
    Department           = var.department_name
    Project              = var.project_name
    Name                 = "NAT Server"
    "Prometheus-monitor" = "enabled"
  }
}
