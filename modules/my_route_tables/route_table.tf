resource "aws_route_table" "my_public_rtb" {
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  tags = {
    Department = var.department_name
    Name       = "${lower(var.project_name)}-public-rtb"
    Project    = var.project_name
  }

  tags_all = {
    Department = var.department_name
    Name       = "${lower(var.project_name)}-public-rtb"
    Project    = var.project_name
  }

  vpc_id = var.vpc_id

  depends_on = [
    var.igw_id,
    var.vpc_id
  ]
}

resource "aws_route_table" "my_application_rtb" {
  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = var.nat_server_eip_assoc_eni_id
  }

  tags = {
    Department = var.department_name
    Name       = "${lower(var.project_name)}-application-rtb"
    Project    = var.project_name
  }

  tags_all = {
    Department = var.department_name
    Name       = "${lower(var.project_name)}-application-rtb"
    Project    = var.project_name
  }

  vpc_id = var.vpc_id

  depends_on = [
    var.nat_server_eip_assoc_eni_id,
    var.vpc_id
  ]
}

resource "aws_route_table" "my_intra_rtb" {
  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = var.nat_server_eip_assoc_eni_id
  }

  tags = {
    Department = var.department_name
    Name       = "${lower(var.project_name)}-intra-rtb"
    Project    = var.project_name
  }

  tags_all = {
    Department = var.department_name
    Name       = "${lower(var.project_name)}-intra-rtb"
    Project    = var.project_name
  }

  vpc_id = var.vpc_id

  depends_on = [
    var.nat_server_eip_assoc_eni_id,
    var.vpc_id
  ]
}

resource "aws_route_table" "my_persistence_rtb" {
  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = var.nat_server_eip_assoc_eni_id
  }

  tags = {
    Department = var.department_name
    Name       = "${lower(var.project_name)}-persistence-rtb"
    Project    = var.project_name
  }

  tags_all = {
    Department = var.department_name
    Name       = "${lower(var.project_name)}-persistence-rtb"
    Project    = var.project_name
  }

  vpc_id = var.vpc_id

  depends_on = [
    var.nat_server_eip_assoc_eni_id,
    var.vpc_id
  ]
}

resource "aws_route_table" "my_nat_server_rtb" {
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  tags = {
    Department = var.department_name
    Name       = "${lower(var.project_name)}-nat-rtb"
    Project    = var.project_name
  }

  tags_all = {
    Department = var.department_name
    Name       = "${lower(var.project_name)}-nat-rtb"
    Project    = var.project_name
  }

  vpc_id = var.vpc_id

  depends_on = [
    var.igw_id,
    var.vpc_id
  ]
}
