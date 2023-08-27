resource "aws_route_table_association" "my_public_rtb_accociation" {
  for_each = { for idx, r in var.public_subnet_ids : idx => r }

  route_table_id = aws_route_table.my_public_rtb.id
  subnet_id      = each.value

  depends_on = [
    var.public_subnet_ids,
    aws_route_table.my_public_rtb
  ]
}

resource "aws_route_table_association" "my_application_rtb_accociation" {
  for_each = { for idx, r in var.application_subnet_ids : idx => r }

  route_table_id = aws_route_table.my_application_rtb.id
  subnet_id      = each.value

  depends_on = [
    var.application_subnet_ids,
    aws_route_table.my_application_rtb
  ]
}

resource "aws_route_table_association" "my_intra_rtb_accociation" {
  for_each = { for idx, r in var.intra_subnet_ids : idx => r }

  route_table_id = aws_route_table.my_intra_rtb.id
  subnet_id      = each.value

  depends_on = [
    var.intra_subnet_ids,
    aws_route_table.my_intra_rtb
  ]
}

resource "aws_route_table_association" "my_persistence_rtb_accociation" {
  for_each = { for idx, r in var.persistence_subnet_ids : idx => r }

  route_table_id = aws_route_table.my_persistence_rtb.id
  subnet_id      = each.value

  depends_on = [
    var.persistence_subnet_ids,
    aws_route_table.my_persistence_rtb
  ]
}

resource "aws_route_table_association" "my_nat_server_rtb_accociation" {
  for_each = { for idx, r in var.nat_server_subnet_ids : idx => r }

  route_table_id = aws_route_table.my_nat_server_rtb.id
  subnet_id      = each.value

  depends_on = [
    var.nat_server_subnet_ids,
    aws_route_table.my_nat_server_rtb
  ]
}
