resource "aws_eks_cluster" "eks_cluster" {
  name                      = var.cluster_name
  enabled_cluster_log_types = ["api", "audit", "authenticator","controllerManager","scheduler"]
  role_arn                  = var.cluster_role_arn

  vpc_config {
    endpoint_private_access = var.endpoint_private_access
    public_access_cidrs     = var.public_access_cidrs
    subnet_ids              = concat(var.public_subnets, var.private_subnets)
  }

  version = var.eks_version

  tags = {
    Name = var.cluster_name
  }

  depends_on = [
    var.cluster_role_arn
  ]
}

data "tls_certificate" "certificate" {
  url = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "oidc_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.certificate.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}
