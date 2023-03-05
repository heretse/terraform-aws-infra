resource "aws_route_table_association" "my_public_rtb_accociation_a" {
  route_table_id = aws_route_table.my_public_rtb.id
  subnet_id      = var.subnet_public_a_id

  depends_on = [
    var.subnet_public_a_id
  ]
}

resource "aws_route_table_association" "my_public_rtb_accociation_c" {
  route_table_id = aws_route_table.my_public_rtb.id
  subnet_id      = var.subnet_public_c_id

  depends_on = [
    var.subnet_public_c_id
  ]
}

resource "aws_route_table_association" "my_public_rtb_accociation_d" {
  route_table_id = aws_route_table.my_public_rtb.id
  subnet_id      = var.subnet_public_d_id

  depends_on = [
    var.subnet_public_d_id
  ]
}

resource "aws_route_table_association" "my_application_rtb_accociation_a" {
  route_table_id = aws_route_table.my_application_rtb.id
  subnet_id      = var.subnet_application_a_id

  depends_on = [
    var.subnet_application_a_id
  ]
}

resource "aws_route_table_association" "my_application_rtb_accociation_c" {
  route_table_id = aws_route_table.my_application_rtb.id
  subnet_id      = var.subnet_application_c_id

  depends_on = [
    var.subnet_application_c_id
  ]
}

resource "aws_route_table_association" "my_application_rtb_accociation_d" {
  route_table_id = aws_route_table.my_application_rtb.id
  subnet_id      = var.subnet_application_d_id

  depends_on = [
    var.subnet_application_d_id
  ]
}

#
resource "aws_route_table_association" "my_intra_rtb_accociation_a" {
  route_table_id = aws_route_table.my_intra_rtb.id
  subnet_id      = var.subnet_intra_a_id

  depends_on = [
    var.subnet_intra_a_id
  ]
}

resource "aws_route_table_association" "my_intra_rtb_accociation_c" {
  route_table_id = aws_route_table.my_intra_rtb.id
  subnet_id      = var.subnet_intra_c_id

  depends_on = [
    var.subnet_intra_c_id
  ]
}

resource "aws_route_table_association" "my_intra_rtb_accociation_d" {
  route_table_id = aws_route_table.my_intra_rtb.id
  subnet_id      = var.subnet_intra_d_id

  depends_on = [
    var.subnet_intra_d_id
  ]
}

resource "aws_route_table_association" "my_persistence_rtb_accociation_a" {
  route_table_id = aws_route_table.my_persistence_rtb.id
  subnet_id      = var.subnet_persistence_a_id

  depends_on = [
    var.subnet_persistence_a_id
  ]
}

resource "aws_route_table_association" "my_persistence_rtb_accociation_c" {
  route_table_id = aws_route_table.my_persistence_rtb.id
  subnet_id      = var.subnet_persistence_c_id

  depends_on = [
    var.subnet_persistence_c_id
  ]
}

resource "aws_route_table_association" "my_persistence_rtb_accociation_d" {
  route_table_id = aws_route_table.my_persistence_rtb.id
  subnet_id      = var.subnet_persistence_d_id

  depends_on = [
    var.subnet_persistence_d_id
  ]
}

resource "aws_route_table_association" "my_nat_server_rtb_accociation" {
  route_table_id = aws_route_table.my_nat_server_rtb.id
  subnet_id      = var.subnet_nat_server_id

  depends_on = [
    var.subnet_nat_server_id
  ]
}
