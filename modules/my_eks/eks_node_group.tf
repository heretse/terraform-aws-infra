resource "aws_eks_node_group" "groups" {
  for_each = { for r in var.node_groups : "${r.name}" => r }

  cluster_name    = var.cluster_name
  node_group_name = each.value.name
  node_role_arn   = each.value.node_role_arn
  subnet_ids      = var.private_subnets
  capacity_type   = each.value.capacity_type
  instance_types  = each.value.instance_types
  disk_size       = each.value.disk_size

  scaling_config {
    desired_size = each.value.desired_nodes
    max_size     = each.value.max_nodes
    min_size     = each.value.min_nodes
  }

  labels = each.value.labels
  dynamic "taint" {
    for_each = lookup(each.value, "taint", [])
    content {
      key    = taint.value.key
      value  = taint.value.value
      effect = taint.value.effect
    }
  }

  depends_on = [
    aws_eks_cluster.eks_cluster,
    var.private_subnets
  ]
}