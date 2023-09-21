variable "aws_region" {
  description = "aws region"
  default     = "ap-northeast-1"
}
variable "aws_profile" {
  description = "Profile in aws/config"
  default     = ""
}

variable "msk_users" {
  type = list(any)
}

variable "server_properties" {
  type = string
}

variable "kafka_cluster_name" {
  type = string
}

variable "kafka_version" {
  type = string
}

variable "kafka_number_of_broker_nodes" {
  type = string
}
variable "kafka_instance_type" {
  type = string
}
variable "kafka_ebs_volume_size" {
  type = number
}

variable "kafka_client_subnets" {
  type = list(any)
}

variable "kafka_security_groups" {
  type = list(any)
}

variable "kafka_scaling_max_capacity" {
  type = number
}

variable "kafka_log_group_name" {
  type    = string
  default = "/nxd/kafka"
}
