output "nxd_public_rtb_id" {
  value = aws_route_table.nxd_public_rtb.id
}

output "nxd_application_rtb_id" {
  value = aws_route_table.nxd_application_rtb.id
}

output "nxd_intra_rtb_id" {
  value = aws_route_table.nxd_intra_rtb.id
}

output "nxd_persistence_rtb_id" {
  value = aws_route_table.nxd_persistence_rtb.id
}

output "nxd_nat_server_rtb_id" {
  value = aws_route_table.nxd_nat_server_rtb.id
}
