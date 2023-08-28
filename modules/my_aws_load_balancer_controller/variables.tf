variable "aws_region" {
    type = string
    description = "AWS Region"
}

variable "chart_version" {
    type = string
    description = "Chart Version of eks/aws-load-balancer-controller"
    default = "1.6.0"
}

variable "vpc_id" {
    type = string
    description = "EKS Cluster VPC ID"
}

variable "vpc_cidr" {
    type = string
    description = "VPC CIDR Block"
}

variable "eks_cluster_name" {
    description = "Name of the EKS Cluster"
}

variable "eks_cluster_endpoint" {
    type = string
    description = "EKS Cluster Endpoint"
}

variable "eks_oidc_url" {
    type = string
    description = "EKS Cluster OIDC Provider URL"
}

variable "eks_ca_certificate" {
    type = string
    description = "EKS Cluster CA Certificate"
}
