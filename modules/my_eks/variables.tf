variable "cluster_name" {
    type        = string
    description = "Name of the EKS Cluster"
}

variable "cluster_role_arn" {
    type        = string
    description = "Role ARN of the EKS Cluster"
}

variable "endpoint_private_access" {
    type        = bool
    default     = false
    description = "Endpoint Private Access of the EKS Cluster"
}

variable "public_subnets" {
    type        = list(any)
    description = "List of all the Public Subnets"
}

variable "private_subnets" {
    type        = list(any)
    description = "List of all the Private Subnets"
}

variable "eks_version" {
    type        = string
    description = "Version of the EKS Cluster"
}

variable "node_groups" {
  type        = list(any)
  description = "List of all the Node Groups"
  default     = []
}

variable "fargate_profiles" {
  type        = list(any)
  description = "List of all the Fargate Profiles"
  default     = []
}
