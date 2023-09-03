data "aws_eks_cluster_auth" "eks_auth" {
  name = var.eks_cluster_name

  depends_on = [
    var.eks_cluster_endpoint,
    var.eks_ca_certificate
  ]
}

data "aws_caller_identity" "current" {}

provider "kubernetes" {
  host                      = var.eks_cluster_endpoint
  cluster_ca_certificate    = base64decode(var.eks_ca_certificate)
  token                     = data.aws_eks_cluster_auth.eks_auth.token
  #load_config_file          = false
}

provider "helm" {
  kubernetes {
    host                   = var.eks_cluster_endpoint
    token                  = data.aws_eks_cluster_auth.eks_auth.token
    cluster_ca_certificate = base64decode(var.eks_ca_certificate)
  }
}
