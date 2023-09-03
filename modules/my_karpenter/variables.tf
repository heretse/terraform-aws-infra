variable "aws_region" {
    type        = string
    description = "AWS Region"
    default     = "ap-northeast-1"
}

variable "chart_version" {
    type        = string
    description = "Chart Version of karpenter/karpenter"
    default     = "v0.20.0"
}

variable "namespace" {
  type        = string
  default     = "karpenter"
  description = "Namespace of karpenter/karpenter"
}

variable "create_namespace" {
  type        = bool
  default     = false
  description = "Needed to Create Namespace of karpenter/karpenter"
}

variable "eks_cluster_name" {
    description = "Name of the EKS Cluster"
}

variable "eks_cluster_endpoint" {
    type        = string
    description = "EKS Cluster Endpoint"
}

variable "eks_oidc_url" {
    type        = string
    description = "EKS Cluster OIDC Provider URL"
}

variable "eks_ca_certificate" {
    type        = string
    description = "EKS Cluster CA Certificate"
}
