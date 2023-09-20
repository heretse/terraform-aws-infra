variable "aws_region" {
  description = "AWS region"
  default     = "ap-northeast-1"
}

variable "aws_profile" {
  description = "AWS profile"
  default     = ""
}

variable "environment" {
  type    = string
  default = ""
}

variable "access_identity_path" {
  type    = string
  default = ""
}

variable "acm_certificate_arn" {
  type    = string
  default = ""
}

variable "distribution_path" {
  type    = string
  default = ""
}

variable "s3_buckets" {
  type    = map(any)
  default = {}
}
