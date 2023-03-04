resource "aws_eip" "nxd_bastion_eip" {
  network_border_group = var.aws_region
  public_ipv4_pool     = "amazon"

  tags = {
    Department = var.department_name
    Name       = "bastion EIP"
    Project    = var.project_name
  }

  tags_all = {
    Department = var.department_name
    Name       = "bastion EIP"
    Project    = var.project_name
  }

  vpc = "true"
}

resource "aws_eip" "nxd_nat_server_eip" {
  network_border_group = var.aws_region
  public_ipv4_pool     = "amazon"

  tags = {
    Department = var.department_name
    Name       = "NAT Public IP"
    Project    = var.project_name
  }

  tags_all = {
    Department = var.department_name
    Name       = "NAT Public IP"
    Project    = var.project_name
  }

  vpc = "true"
}
