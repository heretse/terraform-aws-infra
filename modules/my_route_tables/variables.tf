variable "aws_region" {
  description = "AWS region"
  default     = "ap-northeast-1"
}

variable "aws_profile" {
  description = "AWS profile"
  default     = ""
}

variable "project_name" {
  type        = string
  description = "Project name"
  default     = ""
}

variable "department_name" {
  type        = string
  description = "Department name"
  default     = "SRE"
}

variable "vpc_id" {
  type        = string
  description = "The id of VPC"
}

variable "public_subnet_ids" {
  type    = list(string)
  default = []
}

variable "application_subnet_ids" {
  type    = list(string)
  default = []
}

variable "intra_subnet_ids" {
  type    = list(string)
  default = []
}

variable "persistence_subnet_ids" {
  type    = list(string)
  default = []
}

variable "nat_server_subnet_ids" {
  type    = list(string)
  default = []
}

variable "public_routes" {
  type    = list(any)
  default = []
}

variable "application_routes" {
  type    = list(any)
  default = []
}

variable "intra_routes" {
  type    = list(any)
  default = []
}

variable "persistence_routes" {
  type    = list(any)
  default = []
}

variable "nat_server_routes" {
  type    = list(any)
  default = []
}
