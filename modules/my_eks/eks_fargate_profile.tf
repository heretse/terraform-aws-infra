resource "aws_eks_fargate_profile" "profiles" {
  for_each = { for r in var.fargate_profiles : "${r.name}" => r }

  cluster_name           = var.cluster_name
  fargate_profile_name   = each.value.name
  pod_execution_role_arn = each.value.pod_execution_role_arn
  subnet_ids             = var.private_subnets

  selector {
    namespace = each.value.namespace
  }

  depends_on = [
    var.private_subnets
  ]
}
