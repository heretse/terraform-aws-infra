resource "aws_route_table" "my_public_rtb" {

  dynamic "route" {
    for_each = var.public_routes
    content {
      carrier_gateway_id         = lookup(route.value, "carrier_gateway_id", null)
      cidr_block                 = lookup(route.value, "cidr_block", null)
      destination_prefix_list_id = lookup(route.value, "destination_prefix_list_id", null)
      egress_only_gateway_id     = lookup(route.value, "egress_only_gateway_id", null)
      gateway_id                 = lookup(route.value, "gateway_id", null)
      ipv6_cidr_block            = lookup(route.value, "ipv6_cidr_block", null)
      local_gateway_id           = lookup(route.value, "local_gateway_id", null)
      nat_gateway_id             = lookup(route.value, "nat_gateway_id", null)
      network_interface_id       = lookup(route.value, "network_interface_id", null)
      transit_gateway_id         = lookup(route.value, "transit_gateway_id", null)
      vpc_endpoint_id            = lookup(route.value, "vpc_endpoint_id", null)
      vpc_peering_connection_id  = lookup(route.value, "vpc_peering_connection_id", null)
    }
  }

  tags = {
    Department = var.department_name
    Name       = "${var.project_name}-public-rtb"
    Project    = var.project_name
  }

  tags_all = {
    Department = var.department_name
    Name       = "${var.project_name}-public-rtb"
    Project    = var.project_name
  }

  vpc_id = var.vpc_id

  depends_on = [
    var.vpc_id
  ]
}

resource "aws_route_table" "my_application_rtb" {
  dynamic "route" {
    for_each = var.application_routes
    content {
      carrier_gateway_id         = lookup(route.value, "carrier_gateway_id", null)
      cidr_block                 = lookup(route.value, "cidr_block", null)
      destination_prefix_list_id = lookup(route.value, "destination_prefix_list_id", null)
      egress_only_gateway_id     = lookup(route.value, "egress_only_gateway_id", null)
      gateway_id                 = lookup(route.value, "gateway_id", null)
      # instance_id                = lookup(route.value, "instance_id", null)
      ipv6_cidr_block            = lookup(route.value, "ipv6_cidr_block", null)
      local_gateway_id           = lookup(route.value, "local_gateway_id", null)
      nat_gateway_id             = lookup(route.value, "nat_gateway_id", null)
      network_interface_id       = lookup(route.value, "network_interface_id", null)
      transit_gateway_id         = lookup(route.value, "transit_gateway_id", null)
      vpc_endpoint_id            = lookup(route.value, "vpc_endpoint_id", null)
      vpc_peering_connection_id  = lookup(route.value, "vpc_peering_connection_id", null)
    }
  }

  tags = {
    Department = var.department_name
    Name       = "${var.project_name}-application-rtb"
    Project    = var.project_name
  }

  tags_all = {
    Department = var.department_name
    Name       = "${var.project_name}-application-rtb"
    Project    = var.project_name
  }

  vpc_id = var.vpc_id

  depends_on = [
    var.vpc_id
  ]
}

resource "aws_route_table" "my_intra_rtb" {
  dynamic "route" {
    for_each = var.intra_routes
    content {
      carrier_gateway_id         = lookup(route.value, "carrier_gateway_id", null)
      cidr_block                 = lookup(route.value, "cidr_block", null)
      destination_prefix_list_id = lookup(route.value, "destination_prefix_list_id", null)
      egress_only_gateway_id     = lookup(route.value, "egress_only_gateway_id", null)
      gateway_id                 = lookup(route.value, "gateway_id", null)
      # instance_id                = lookup(route.value, "instance_id", null)
      ipv6_cidr_block            = lookup(route.value, "ipv6_cidr_block", null)
      local_gateway_id           = lookup(route.value, "local_gateway_id", null)
      nat_gateway_id             = lookup(route.value, "nat_gateway_id", null)
      network_interface_id       = lookup(route.value, "network_interface_id", null)
      transit_gateway_id         = lookup(route.value, "transit_gateway_id", null)
      vpc_endpoint_id            = lookup(route.value, "vpc_endpoint_id", null)
      vpc_peering_connection_id  = lookup(route.value, "vpc_peering_connection_id", null)
    }
  }

  tags = {
    Department = var.department_name
    Name       = "${var.project_name}-intra-rtb"
    Project    = var.project_name
  }

  tags_all = {
    Department = var.department_name
    Name       = "${var.project_name}-intra-rtb"
    Project    = var.project_name
  }

  vpc_id = var.vpc_id

  depends_on = [
    var.vpc_id
  ]
}

resource "aws_route_table" "my_persistence_rtb" {
  dynamic "route" {
    for_each = var.persistence_routes
    content {
      carrier_gateway_id         = lookup(route.value, "carrier_gateway_id", null)
      cidr_block                 = lookup(route.value, "cidr_block", null)
      destination_prefix_list_id = lookup(route.value, "destination_prefix_list_id", null)
      egress_only_gateway_id     = lookup(route.value, "egress_only_gateway_id", null)
      gateway_id                 = lookup(route.value, "gateway_id", null)
      # instance_id                = lookup(route.value, "instance_id", null)
      ipv6_cidr_block            = lookup(route.value, "ipv6_cidr_block", null)
      local_gateway_id           = lookup(route.value, "local_gateway_id", null)
      nat_gateway_id             = lookup(route.value, "nat_gateway_id", null)
      network_interface_id       = lookup(route.value, "network_interface_id", null)
      transit_gateway_id         = lookup(route.value, "transit_gateway_id", null)
      vpc_endpoint_id            = lookup(route.value, "vpc_endpoint_id", null)
      vpc_peering_connection_id  = lookup(route.value, "vpc_peering_connection_id", null)
    }
  }

  tags = {
    Department = var.department_name
    Name       = "${var.project_name}-persistence-rtb"
    Project    = var.project_name
  }

  tags_all = {
    Department = var.department_name
    Name       = "${var.project_name}-persistence-rtb"
    Project    = var.project_name
  }

  vpc_id = var.vpc_id

  depends_on = [
    var.vpc_id
  ]
}

resource "aws_route_table" "my_nat_server_rtb" {
  dynamic "route" {
    for_each = var.nat_server_routes
    content {
      carrier_gateway_id         = lookup(route.value, "carrier_gateway_id", null)
      cidr_block                 = lookup(route.value, "cidr_block", null)
      destination_prefix_list_id = lookup(route.value, "destination_prefix_list_id", null)
      egress_only_gateway_id     = lookup(route.value, "egress_only_gateway_id", null)
      gateway_id                 = lookup(route.value, "gateway_id", null)
      # instance_id                = lookup(route.value, "instance_id", null)
      ipv6_cidr_block            = lookup(route.value, "ipv6_cidr_block", null)
      local_gateway_id           = lookup(route.value, "local_gateway_id", null)
      nat_gateway_id             = lookup(route.value, "nat_gateway_id", null)
      network_interface_id       = lookup(route.value, "network_interface_id", null)
      transit_gateway_id         = lookup(route.value, "transit_gateway_id", null)
      vpc_endpoint_id            = lookup(route.value, "vpc_endpoint_id", null)
      vpc_peering_connection_id  = lookup(route.value, "vpc_peering_connection_id", null)
    }
  }

  tags = {
    Department = var.department_name
    Name       = "${var.project_name}-nat-rtb"
    Project    = var.project_name
  }

  tags_all = {
    Department = var.department_name
    Name       = "${var.project_name}-nat-rtb"
    Project    = var.project_name
  }

  vpc_id = var.vpc_id

  depends_on = [
    var.vpc_id
  ]
}
