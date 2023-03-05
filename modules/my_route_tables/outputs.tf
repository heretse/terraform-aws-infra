output "my_public_rtb_id" {
  value = aws_route_table.my_public_rtb.id
}

output "my_application_rtb_id" {
  value = aws_route_table.my_application_rtb.id
}

output "my_intra_rtb_id" {
  value = aws_route_table.my_intra_rtb.id
}

output "my_persistence_rtb_id" {
  value = aws_route_table.my_persistence_rtb.id
}

output "my_nat_server_rtb_id" {
  value = aws_route_table.my_nat_server_rtb.id
}
