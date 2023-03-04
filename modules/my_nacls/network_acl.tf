resource "aws_network_acl" "my_nat_acl" {
  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "-1"
    rule_no    = "100"
    to_port    = "0"
  }

  ingress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "-1"
    rule_no    = "100"
    to_port    = "0"
  }

  subnet_ids = [
    var.subnet_intra_a_id,
    var.subnet_intra_c_id,
    var.subnet_intra_d_id,
    var.subnet_nat_server_id
  ]

  tags = {
    Department = var.department_name
    Name       = "${lower(var.project_name)}-nat"
    Project    = var.project_name
  }

  tags_all = {
    Department = var.department_name
    Name       = "${lower(var.project_name)}-nat"
    Project    = var.project_name
  }

  vpc_id = var.vpc_id

  depends_on = [
    var.subnet_intra_a_id,
    var.subnet_intra_c_id,
    var.subnet_intra_d_id,
    var.subnet_nat_server_id,
    var.vpc_id
  ]
}

resource "aws_network_acl" "my_public_acl" {
  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    icmp_code  = "-1"
    icmp_type  = "-1"
    protocol   = "1"
    rule_no    = "3"
    to_port    = "0"
  }

  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "6"
    rule_no    = "1"
    to_port    = "65535"
  }

  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "1024"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "6"
    rule_no    = "119"
    to_port    = "65535"
  }

  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "22"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "6"
    rule_no    = "120"
    to_port    = "22"
  }

  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "443"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "6"
    rule_no    = "110"
    to_port    = "443"
  }

  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "80"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "6"
    rule_no    = "100"
    to_port    = "80"
  }

  egress {
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = "0"
    icmp_code  = "-1"
    icmp_type  = "0"
    protocol   = "1"
    rule_no    = "141"
    to_port    = "0"
  }

  egress {
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = "0"
    icmp_code  = "-1"
    icmp_type  = "8"
    protocol   = "1"
    rule_no    = "140"
    to_port    = "0"
  }

  ingress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    icmp_code  = "-1"
    icmp_type  = "-1"
    protocol   = "1"
    rule_no    = "10"
    to_port    = "0"
  }

  ingress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "17"
    rule_no    = "1000"
    to_port    = "65535"
  }

  ingress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "1024"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "6"
    rule_no    = "999"
    to_port    = "65535"
  }

  ingress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "443"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "6"
    rule_no    = "110"
    to_port    = "443"
  }

  ingress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "22"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "6"
    rule_no    = "50"
    to_port    = "22"
  }

  ingress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "80"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "6"
    rule_no    = "100"
    to_port    = "80"
  }

  subnet_ids = [
    var.subnet_public_a_id,
    var.subnet_public_c_id,
    var.subnet_public_d_id
  ]

  tags = {
    Department = var.department_name
    Name       = "${lower(var.project_name)}-public"
    Project    = var.project_name
  }

  tags_all = {
    Department = var.department_name
    Name       = "${lower(var.project_name)}-public"
    Project    = var.project_name
  }

  vpc_id = var.vpc_id

  depends_on = [
    var.subnet_public_a_id,
    var.subnet_public_c_id,
    var.subnet_public_d_id,
    var.vpc_id
  ]
}

resource "aws_network_acl" "my_application_acl" {
  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    icmp_code  = "-1"
    icmp_type  = "-1"
    protocol   = "1"
    rule_no    = "140"
    to_port    = "0"
  }

  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "-1"
    rule_no    = "1"
    to_port    = "0"
  }

  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "1024"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "6"
    rule_no    = "130"
    to_port    = "65535"
  }

  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "22"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "6"
    rule_no    = "802"
    to_port    = "22"
  }

  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "443"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "6"
    rule_no    = "110"
    to_port    = "443"
  }

  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "80"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "6"
    rule_no    = "100"
    to_port    = "80"
  }

  egress {
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = "23"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "6"
    rule_no    = "900"
    to_port    = "65535"
  }

  ingress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    icmp_code  = "-1"
    icmp_type  = "-1"
    protocol   = "1"
    rule_no    = "140"
    to_port    = "0"
  }

  ingress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "-1"
    rule_no    = "1002"
    to_port    = "0"
  }

  ingress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "17"
    rule_no    = "1"
    to_port    = "65535"
  }

  ingress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "1024"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "6"
    rule_no    = "130"
    to_port    = "65535"
  }

  ingress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "22"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "6"
    rule_no    = "1000"
    to_port    = "22"
  }

  ingress {
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = "22"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "6"
    rule_no    = "120"
    to_port    = "22"
  }

  ingress {
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = "23"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "6"
    rule_no    = "900"
    to_port    = "65535"
  }

  ingress {
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = "80"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "6"
    rule_no    = "999"
    to_port    = "80"
  }

  subnet_ids = [
    var.subnet_application_a_id,
    var.subnet_application_c_id,
    var.subnet_application_d_id
  ]

  tags = {
    Department = var.department_name
    Name       = "${lower(var.project_name)}-application"
    Project    = var.project_name
  }

  tags_all = {
    Department = var.department_name
    Name       = "${lower(var.project_name)}-application"
    Project    = var.project_name
  }

  vpc_id = var.vpc_id

  depends_on = [
    var.subnet_application_a_id,
    var.subnet_application_c_id,
    var.subnet_application_d_id,
    var.vpc_id
  ]
}

resource "aws_network_acl" "my_persistence_acl" {
  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "32768"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "6"
    rule_no    = "130"
    to_port    = "65535"
  }

  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "443"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "6"
    rule_no    = "110"
    to_port    = "443"
  }

  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "80"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "6"
    rule_no    = "100"
    to_port    = "80"
  }

  egress {
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = "0"
    icmp_code  = "-1"
    icmp_type  = "0"
    protocol   = "1"
    rule_no    = "141"
    to_port    = "0"
  }

  egress {
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = "0"
    icmp_code  = "-1"
    icmp_type  = "8"
    protocol   = "1"
    rule_no    = "140"
    to_port    = "0"
  }

  egress {
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = "23"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "6"
    rule_no    = "900"
    to_port    = "65535"
  }

  ingress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "6"
    rule_no    = "1"
    to_port    = "65535"
  }

  ingress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "32768"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "6"
    rule_no    = "130"
    to_port    = "65535"
  }

  ingress {
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = "0"
    icmp_code  = "-1"
    icmp_type  = "0"
    protocol   = "1"
    rule_no    = "141"
    to_port    = "0"
  }

  ingress {
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = "0"
    icmp_code  = "-1"
    icmp_type  = "8"
    protocol   = "1"
    rule_no    = "140"
    to_port    = "0"
  }

  ingress {
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = "22"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "6"
    rule_no    = "120"
    to_port    = "22"
  }

  ingress {
    action     = "allow"
    cidr_block = var.vpc_cidr
    from_port  = "23"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "6"
    rule_no    = "900"
    to_port    = "65535"
  }

  subnet_ids = [
    var.subnet_persistence_a_id,
    var.subnet_persistence_c_id,
    var.subnet_persistence_d_id
  ]

  tags = {
    Department = var.department_name
    Name       = "${lower(var.project_name)}-persistence"
    Project    = var.project_name
  }

  tags_all = {
    Department = var.department_name
    Name       = "${lower(var.project_name)}-persistence"
    Project    = var.project_name
  }

  vpc_id = var.vpc_id

  depends_on = [
    var.subnet_persistence_a_id,
    var.subnet_persistence_c_id,
    var.subnet_persistence_d_id,
    var.vpc_id
  ]
}
